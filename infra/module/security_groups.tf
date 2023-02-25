resource "aws_default_security_group" "app_vpc_primary_default_sg" {
  vpc_id = aws_vpc.app_vpc_primary.id
}

resource "aws_security_group" "app_sg_ec2" {
  #checkov:skip=CKV2_AWS_5:task is handled outside of TF but needs this SG
  name        = "${lower(var.app_name)}-botdr-sg-ec2"
  description = "controls network access to EC2 from the lb"
  vpc_id      = aws_vpc.app_vpc_primary.id

  ingress {
    protocol    = "UDP"
    description = "allows 5121 udp into nwserver as the default port from public subnet"
    from_port   = 5121
    to_port     = 5121
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    description = "allows 22 inside VPC"
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.app_subnet_public.cidr_block
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    description = "needed for SSM"
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    description = "ICMP inside VPC"
    protocol    = "ICMP"
    cidr_blocks = [
      aws_subnet.app_subnet_public.cidr_block
    ]
  }

  egress {
    from_port   = -1
    to_port     = -1
    description = "ICMP outbound anywhere"
    protocol    = "ICMP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 443
    to_port     = 443
    description = "needed for SSM"
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 80
    to_port     = 80
    description = "needed for SSM"
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol    = "-1"
    description = "allow out any/any"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "app_sg_ssm" {
  name        = "${lower(var.app_name)}-botdr-sg-ssm"
  description = "controls network access to ssm inside VPC"
  vpc_id      = aws_vpc.app_vpc_primary.id

  ingress {
    from_port   = 443
    to_port     = 443
    description = "allow 443 in for SSM endpoints"
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    description = "allow ICMP out"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow any/any to private subnet"
    cidr_blocks = [
      aws_subnet.app_subnet_public.cidr_block
    ]
  }
}
