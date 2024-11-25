terraform {
  required_version = "1.9.8"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "botdr" {
  source                = "./botdr"
  env                   = var.env
  vpc_id                = var.vpc_id
  github_sha            = var.github_sha
  botdr_dm_password     = var.botdr_dm_password
  botdr_player_password = var.botdr_player_password
  botdr_admin_password  = var.botdr_admin_password
}
