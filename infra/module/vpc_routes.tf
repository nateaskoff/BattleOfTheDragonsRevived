resource "aws_route_table" "app_route_table_public" {
  vpc_id = aws_vpc.app_vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_internet_gateway_primary.id
  }
}

resource "aws_route_table_association" "app_route_table_assoc_public" {
  subnet_id      = aws_subnet.app_subnet_public.id
  route_table_id = aws_route_table.app_route_table_public.id
}
