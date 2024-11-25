resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.env}-botdr-ecr-repo"
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.botdr_key.arn
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.env}-botdr-ecr-repo"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire images older than 14 days",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 5
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2,
        description  = "Retain last 5 images with prefix 'botdr-'",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["botdr-"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
