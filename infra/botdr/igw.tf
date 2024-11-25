resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary_vpc.id
  tags = {
    Name = "${var.env}-botdr-igw"
  }
}
