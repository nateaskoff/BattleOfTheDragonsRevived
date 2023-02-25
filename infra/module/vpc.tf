resource "aws_vpc" "app_vpc_primary" {
  #checkov:skip=CKV2_AWS_11
  cidr_block           = "10.200.20.0/23"
  enable_dns_hostnames = true
  enable_dns_support   = true
}
