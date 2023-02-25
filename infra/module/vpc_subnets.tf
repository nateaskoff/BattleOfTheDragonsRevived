resource "aws_subnet" "app_subnet_public" {
  cidr_block        = "10.200.20.0/24"
  vpc_id            = aws_vpc.app_vpc_primary.id
  availability_zone = "${var.aws_region}a"
}
