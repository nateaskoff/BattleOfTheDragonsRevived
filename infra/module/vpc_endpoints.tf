resource "aws_vpc_endpoint" "ssm" {
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id            = aws_vpc.app_vpc_primary.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.app_subnet_public.id
  ]
  security_group_ids = [
    aws_security_group.app_sg_ssm.id
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_id            = aws_vpc.app_vpc_primary.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.app_subnet_public.id
  ]
  security_group_ids = [
    aws_security_group.app_sg_ssm.id
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_id            = aws_vpc.app_vpc_primary.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.app_subnet_public.id
  ]
  security_group_ids = [
    aws_security_group.app_sg_ssm.id
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_id            = aws_vpc.app_vpc_primary.id
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.app_route_table_public.id
  ]
}

resource "aws_vpc_endpoint_route_table_association" "app_vpc_ep_rt_assoc_s3" {
  route_table_id  = aws_route_table.app_route_table_public.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
