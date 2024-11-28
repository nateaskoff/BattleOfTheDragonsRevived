variable "env" {
  type        = string
  description = "The environment to deploy to"
}

variable "vpc_id" {
  type        = number
  description = "Defines the 2nd octet of the VPC CIDR block"
}

variable "github_sha" {
  type        = string
  description = "The SHA of the commit to deploy"
}

variable "botdr_dm_password" {
  type        = string
  description = "The password for DM access to the BOTDR module"
  sensitive   = true
}

variable "botdr_player_password" {
  type        = string
  description = "The password for player access to the BOTDR module in DEV"
  sensitive   = true
}

variable "botdr_admin_password" {
  type        = string
  description = "The password for admin access to the BOTDR module"
  sensitive   = true
}

variable "botdr_ecs_cpu" {
  type        = number
  description = "The number of CPU units to allocate to the ECS task"
}

variable "botdr_ecs_memory" {
  type        = number
  description = "The amount of memory to allocate to the ECS task"
}
