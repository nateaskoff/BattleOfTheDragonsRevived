resource "aws_secretsmanager_secret" "botdr_dm_password" {
  #checkov:skip=CKV2_AWS_57: no rotation for now
  name       = "botdr_dm_password"
  kms_key_id = aws_kms_key.botdr_key.arn
}

resource "aws_secretsmanager_secret" "botdr_player_password" {
  #checkov:skip=CKV2_AWS_57: no rotation for now
  count = var.env == "dev" ? 1 : 0

  name       = "botdr_player_password"
  kms_key_id = aws_kms_key.botdr_key.arn
}

resource "aws_secretsmanager_secret_version" "botdr_dm_password" {
  secret_id     = aws_secretsmanager_secret.botdr_dm_password.id
  secret_string = var.botdr_dm_password
}

resource "aws_secretsmanager_secret_version" "botdr_player_password" {
  count = var.env == "dev" ? 1 : 0

  secret_id     = aws_secretsmanager_secret.botdr_player_password[count.index].id
  secret_string = var.botdr_player_password
}
