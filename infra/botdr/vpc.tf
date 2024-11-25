resource "aws_vpc" "primary_vpc" {
  #checkov:skip=CKV2_AWS_11:implement flow logging later
  cidr_block           = "172.${var.vpc_id}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-botdr-vpc-primary"
  }
}
