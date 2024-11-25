resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env}-botdr-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
