resource "aws_ecs_service" "ecs_service" {
  #checkov:skip=CKV_AWS_333:project requires public ip to save cost
  name                               = "${var.env}-botdr-ecs-service"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_task_def.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  enable_execute_command             = true


  network_configuration {
    subnets = [
      aws_subnet.public_subnet.id
    ]
    security_groups = [
      aws_security_group.ecs_security_group.id
    ]
    assign_public_ip = true
  }
}
