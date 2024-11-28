resource "aws_ebs_volume" "server_vault_volume" {
  size              = 20
  type              = "gp3"
  availability_zone = aws_subnet.public_subnet.availability_zone
  encrypted         = true
  kms_key_id        = aws_kms_key.botdr_key.arn

  tags = {
    Name = "${var.env}-botdr-server-vault-volume"
  }
}
