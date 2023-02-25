resource "aws_s3_bucket" "app_s3_logs_bucket" {
  #checkov:skip=CKV_AWS_21
  #checkov:skip=CKV_AWS_144
  #checkov:skip=CKV_AWS_19
  #checkov:skip=CKV_AWS_145:no s3 encryption to save costs
  #checkov:skip=CKV_AWS_18:remove logging bucket to reduce cost
  bucket        = "${lower(var.app_name)}-botdr-s3-logs-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "app_s3_logs_s3_bucket_acl" {
  bucket = aws_s3_bucket.app_s3_logs_bucket.bucket
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "app_s3_logs_s3_bucket_lifecycle_config" {
  bucket = aws_s3_bucket.app_s3_logs_bucket.bucket

  rule {
    id = "shared-s3-logs-bucket-lifecycle-policy"

    status = "Enabled"

    filter {
      prefix = "Ansible/"
    }

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_s3_logs_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.app_s3_logs_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "app_s3_logs_s3_iam_policy_document" {
  statement {
    sid = "1"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.app_ec2_iam_role.arn
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.app_s3_logs_bucket.arn,
      "${aws_s3_bucket.app_s3_logs_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "app_s3_logs_s3_bucket_policy" {
  bucket = aws_s3_bucket.app_s3_logs_bucket.bucket
  policy = data.aws_iam_policy_document.app_s3_logs_s3_iam_policy_document.json
}

resource "aws_s3_bucket_public_access_block" "app_s3_logs_s3_public_access_block" {
  bucket = aws_s3_bucket.app_s3_logs_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
