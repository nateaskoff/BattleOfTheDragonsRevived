resource "aws_s3_bucket" "web_bucket" {
  #checkov:skip=CKV_AWS_300
  #checkov:skip=CKV_AWS_21:versioning is in github
  #checkov:skip=CKV_AWS_145:cannot use kms with cloudfront
  #checkov:skip=CKV2_AWS_62
  #checkov:skip=CKV_AWS_18
  #checkov:skip=CKV_AWS_144
  bucket = "${lower(var.env)}-botdr-primary-site-web-bucket"
}

resource "aws_s3_bucket_public_access_block" "web_bucket_acc_blk" {
  bucket = aws_s3_bucket.web_bucket.id

  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = data.aws_iam_policy_document.s3_web_bucket_policy.json
}

resource "aws_s3_bucket_lifecycle_configuration" "web_bucket_lifecycle" {
  bucket = aws_s3_bucket.web_bucket.id

  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    filter {}
  }
}

resource "aws_s3_bucket" "mod_bucket" {
  #checkov:skip=CKV_AWS_300
  #checkov:skip=CKV2_AWS_62
  #checkov:skip=CKV_AWS_18
  #checkov:skip=CKV_AWS_144
  bucket = "${lower(var.env)}-botdr-mod-bucket"
}

resource "aws_s3_bucket_public_access_block" "mod_bucket_acc_blk" {
  bucket = aws_s3_bucket.mod_bucket.id

  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "mod_bucket_versioning" {
  bucket = aws_s3_bucket.mod_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "mod_bucket_lifecycle" {
  bucket = aws_s3_bucket.mod_bucket.id

  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    filter {}
  }

  rule {
    id     = "expire-deleted-objects-30-days"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mod_bucket_sse" {
  bucket = aws_s3_bucket.mod_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.botdr_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
