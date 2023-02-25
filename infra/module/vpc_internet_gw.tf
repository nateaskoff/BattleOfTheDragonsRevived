resource "aws_internet_gateway" "app_internet_gateway_primary" {
  vpc_id = aws_vpc.app_vpc_primary.id
}
