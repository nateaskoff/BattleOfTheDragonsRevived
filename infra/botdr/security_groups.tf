resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.primary_vpc.id
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id      = aws_vpc.primary_vpc.id
  name        = "${var.env}-botdr-ecs-security-group"
  description = "Security group for the ECS service for BOTDR in the ${var.env} environment"
}

resource "aws_security_group_rule" "udp_ingress_5121" {
  type              = "ingress"
  description       = "Allow inbound traffic on port 5121"
  from_port         = 5121
  to_port           = 5121
  protocol          = "udp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "udp_egress_5121" {
  type              = "egress"
  description       = "Allow outbound traffic on port 5121"
  from_port         = 5121
  to_port           = 5121
  protocol          = "udp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "tcp_ingress_443" {
  type              = "ingress"
  description       = "Allow inbound traffic on port 443"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "tcp_egress_443" {
  type              = "egress"
  description       = "Allow outbound traffic on port 443"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "tcp_ingress_53" {
  type              = "ingress"
  description       = "Allow inbound traffic on port 53"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "tcp_egress_53" {
  type              = "egress"
  description       = "Allow outbound traffic on port 53"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "tcp_ingress_pub_2049" {
  type              = "ingress"
  description       = "Allow inbound traffic on port 2049"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks = [
    aws_subnet.public_subnet.cidr_block
  ]
}

resource "aws_security_group" "efs_sec_grp" {
  vpc_id      = aws_vpc.primary_vpc.id
  name        = "${var.env}-botdr-efs-security-group"
  description = "Security group for the EFS service for BOTDR in the ${var.env} environment"
}

resource "aws_security_group_rule" "efs_ingress" {
  type              = "ingress"
  description       = "Allow inbound traffic on all ports"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.efs_sec_grp.id
  cidr_blocks = [
    aws_subnet.public_subnet.cidr_block
  ]
}

resource "aws_security_group_rule" "efs_egress" {
  type              = "egress"
  description       = "Allow outbound traffic on all ports"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.efs_sec_grp.id
  cidr_blocks = [
    aws_subnet.public_subnet.cidr_block
  ]
}
