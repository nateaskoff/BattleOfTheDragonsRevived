data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-20.04*",
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }

  filter {
    name = "root-device-type"
    values = [
      "ebs"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }
}

data "aws_iam_policy" "ec2_read_only" {
  name = "AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "ec2_s3_ro" {
  name = "AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy" "ec2_ssm_inst_def" {
  name = "AmazonSSMManagedEC2InstanceDefaultPolicy"
}

data "aws_iam_policy" "ec2_ssm_inst_ssm" {
  name = "AmazonSSMManagedInstanceCore"
}
