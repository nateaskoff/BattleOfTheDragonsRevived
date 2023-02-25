### module TG file
terraform {
  source = "module/"
}

locals {
  TF_HOSTNAME = "app.terraform.io"
  TF_ORG      = "BattleOfTheDragonsRevived"

  AWS_ACCOUNT_ID   = get_env("AWS_ACCOUNT_ID")
  AWS_ENV          = get_env("AWS_ENV")
  AWS_REGION       = get_env("AWS_REGION")
  AWS_ROLE_NAME    = get_env("AWS_ROLE_NAME")
  AWS_REGION_SHORT = join("", [for tok in split("-", local.AWS_REGION) : substr(tok, 0, 1)])
  TF_WORKSPACE     = "BOTDR-${upper(local.AWS_ENV)}-${upper(local.AWS_REGION_SHORT)}"

  NW_DM_PW       = get_env("NW_DM_PW")
  NW_ADMIN_PW    = get_env("NW_ADMIN_PW")
  NW_SERVER_NAME = get_env("NW_SERVER_NAME")
}

generate "terragrunt-tfvars" {
  path              = "terragrunt.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
  app_name              = "${local.AWS_ENV}"
  nw_server_name        = "${local.NW_SERVER_NAME}"
  aws_region            = "${local.AWS_REGION}"
  aws_tf_rel_role_name  = "${local.AWS_ROLE_NAME}"
  nw_dm_pw              = "${local.NW_DM_PW}"
  nw_admin_pw           = "${local.NW_ADMIN_PW}"
EOF
}

generate "versions-tf" {
  path              = "versions.tf"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
terraform {
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }
  }
}
EOF
}

generate "remote-state-tf" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "remote" {
    hostname      = "${local.TF_HOSTNAME}"
    organization  = "${local.TF_ORG}"
    workspaces {
      name = "${local.TF_WORKSPACE}"
    }
  }
}
EOF
}

generate "provider-tf" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "aws" {
  region      = "${local.AWS_REGION}"
  access_key  = "${get_env("AWS_ACCESS_KEY_ID")}"
  secret_key  = "${get_env("AWS_SECRET_ACCESS_KEY")}"
  assume_role {
    role_arn = "arn:aws:iam::${local.AWS_ACCOUNT_ID}:role/${local.AWS_ROLE_NAME}"
  }
}
EOF
}
