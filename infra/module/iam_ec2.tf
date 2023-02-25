resource "aws_iam_role" "app_ec2_iam_role" {
  name = "${lower(var.app_name)}-ec2-iam-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Principal = {
            Service = "ec2.amazonaws.com"
          },
          Effect = "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "app_ec2_iam_policy" {
  name = "${lower(var.app_name)}-iam-pol-ec2"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "S3:ListObject",
            "S3:GetObject"
          ]
          Effect = "Allow"
          Resource = [
            aws_s3_bucket.app_s3_mod_bucket.arn,
            "${aws_s3_bucket.app_s3_mod_bucket.arn}/*"
          ]
        },
        {
          Action = [
            "S3:ListObject",
            "S3:GetObject",
            "S3:PutObject"
          ]
          Effect = "Allow"
          Resource = [
            aws_s3_bucket.app_s3_logs_bucket.arn,
            "${aws_s3_bucket.app_s3_logs_bucket.arn}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "app_ec2_iam_role_policy_attachment" {
  role       = aws_iam_role.app_ec2_iam_role.name
  policy_arn = aws_iam_policy.app_ec2_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "app_ec2_iam_role_policy_attachment_ro" {
  role       = aws_iam_role.app_ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ec2_read_only.arn
}

resource "aws_iam_role_policy_attachment" "app_ec2_iam_role_policy_attachment_ssm_def" {
  role       = aws_iam_role.app_ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ec2_ssm_inst_def.arn
}

resource "aws_iam_role_policy_attachment" "app_ec2_iam_role_policy_attachment_ssm" {
  role       = aws_iam_role.app_ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ec2_ssm_inst_ssm.arn
}

resource "aws_iam_role_policy_attachment" "app_ec2_iam_role_policy_attachment_s3_ro" {
  role       = aws_iam_role.app_ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ec2_s3_ro.arn
}
