resource "aws_route_table" "primary_vpc_route_table" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "${var.env}-botdr-primary-vpc-route-table"
  }
}

resource "aws_route_table_association" "primary_vpc_route_table_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.primary_vpc_route_table.id
}
