variable "app_name" {
  type        = string
  description = "Application name which everything is based off of"
}

variable "nw_server_name" {
  type        = string
  description = "name of the server to differentiate dev and prod"
}

variable "aws_region" {
  type        = string
  description = "Region of AWS being deployed to"
}

variable "aws_tf_rel_role_name" {
  type        = string
  description = "The role name responsible for terraform release processes"
  sensitive   = true
}

variable "nw_dm_pw" {
  type        = string
  description = "DM password for NWN module"
  sensitive   = true
}

variable "nw_admin_pw" {
  type        = string
  description = "Admin password for NWN module"
  sensitive   = true
}
