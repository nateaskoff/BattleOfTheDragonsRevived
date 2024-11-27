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
          name = "NWN_PORT"
          value = "5121"
        },
        {
          name = "NWN_MODULE"
          value = "Battle_Of_The_Dragons_Revived"
        },
        {
          name = "NWN_SERVERNAME"
          value = "Battle Of The Dragons Revived BETA"
        },
        {
          name = "NWN_PUBLICSERVER"
          value = "1"
        },
        {
          name = "NWN_MAXCLIENTS"
          value = "40"
        },
        {
          name = "NWN_MINLEVEL"
          value = "1"
        },
        {
          name = "NWN_MAXLEVEL"
          value = "20"
        },
        {
          name = "NWN_PAUSEANDPLAY"
          value = "0"
        },
        {
          name = "NWN_PVP"
          value = "1"
        },
        {
          name = "NWN_SERVERVAULT"
          value = "0"
        },
        {
          name = "NWN_ELC"
          value = "1"
        },
        {
          name = "NWN_ILR"
          value = "1"
        },
        {
          name = "NWN_GAMETYPE"
          value = "0"
        },
        {
          name = "NWN_ONEPARTY"
          value = "0"
        },
        {
          name = "NWN_DIFFICULTY"
          value = "4"
        },
        {
          name = "NWN_RELOADWHENEMPTY"
          value = "0"
        },
        {
          name = "NWN_PLAYERPASSWORD"
          value = var.env == "dev" ? var.botdr_player_password : ""
        },
        {
          name = "NWN_ADMINPASSWORD"
          value = var.botdr_admin_password
        },
        {
          name = "NWN_DMPASSWORD"
          value = var.botdr_dm_password
        }
      ]
    }
  ])
}
