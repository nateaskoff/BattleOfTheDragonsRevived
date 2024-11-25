data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "botdr_zone" {
  name = "battleofthedragonsrevived.com"
}

data "aws_iam_policy_document" "s3_web_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.web_bucket.arn,
      "${aws_s3_bucket.web_bucket.arn}/*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cf_dist_botdr_web.id}"
      ]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_policy_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.botdr_key.arn
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      aws_ecr_repository.ecr_repo.arn
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.ecs_log_group.arn,
      "${aws_cloudwatch_log_group.ecs_log_group.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.mod_bucket.arn,
      "${aws_s3_bucket.mod_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.botdr_key.arn
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      aws_ecr_repository.ecr_repo.arn
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.ecs_log_group.arn,
      "${aws_cloudwatch_log_group.ecs_log_group.arn}:*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.botdr_dm_password.arn,
      aws_secretsmanager_secret.botdr_admin_password.arn
    ]
  }

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_role_policy_dev_player_pw" {
  count = var.env == "dev" ? 1 : 0

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.botdr_player_password[count.index].arn
    ]
  }
}
