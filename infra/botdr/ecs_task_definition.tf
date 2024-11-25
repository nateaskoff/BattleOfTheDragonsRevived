resource "aws_ecs_task_definition" "ecs_task_def" {
  #checkov:skip=CKV_AWS_336: nwserver requires read/write as the binary is only looking at the user's modules folder to load modules
  family                   = "${var.env}-botdr-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.env}-botdr-ecs-container"
      image     = "${aws_ecr_repository.ecr_repo.repository_url}:botdr-${var.github_sha}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5121
          protocol      = "udp"
        }
      ]
      readonlyRootFilesystem = false
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "${var.env}-botdr-ecs-container"
        }
      }
      environment = [
        {
          name  = "ECS_ENABLE_CONTAINER_METADATA"
          value = "true"
        },
        {
          name  = "APP_ENV",
          value = var.env
        },
        {
          name  = "AWS_S3_MOD_BUCKET_ID",
          value = aws_s3_bucket.mod_bucket.id
        },
        {
          name  = "BOTDR_DM_PASSWORD_SECRET_ARN",
          value = aws_secretsmanager_secret.botdr_dm_password.arn
        },
        {
          name  = "BOTDR_PLAYER_PASSWORD_SECRET_ARN",
          value = var.env == "dev" ? aws_secretsmanager_secret.botdr_player_password[0].arn : ""
        }
      ]
    }
  ])
}
