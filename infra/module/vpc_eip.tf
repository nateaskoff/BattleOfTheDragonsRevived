resource "aws_eip" "app_eip_ec2_primary" {
  instance = aws_instance.app_ec2_primary.id
  vpc      = true
}
