resource "aws_cloudwatch_log_group" "ecs_log_group" {
  #checkov:skip=CKV_AWS_338:keep retention to 1 day for hobby project
  name              = "/ecs/${var.env}-botdr-ecs-service"
  retention_in_days = 1
  kms_key_id        = aws_kms_key.botdr_key.arn

  depends_on = [
    aws_kms_key.botdr_key,
    aws_kms_alias.botdr_key_alias,
    aws_kms_key_policy.botdr_key_policy
  ]
}
