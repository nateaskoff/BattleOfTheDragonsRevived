resource "aws_route" "primary_route_public_to_igw" {
  route_table_id         = aws_route_table.primary_vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
