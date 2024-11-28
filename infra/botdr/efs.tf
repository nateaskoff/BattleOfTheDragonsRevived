resource "aws_efs_file_system" "server_vault_fs" {
  creation_token   = "${var.env}-botdr-efs-server-vault"
  encrypted        = true
  kms_key_id       = aws_kms_key.botdr_key.arn
  performance_mode = "generalPurpose"


  tags = {
    Name = "${var.env}-botdr-efs-server-vault"
  }
}

resource "aws_efs_mount_target" "server_vault_fs_mt" {
  file_system_id = aws_efs_file_system.server_vault_fs.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_efs_file_system_policy" "server_vault_fs_mt_policy" {
  file_system_id = aws_efs_file_system.server_vault_fs.id
  policy         = data.aws_iam_policy_document.efs_policy.json
}
