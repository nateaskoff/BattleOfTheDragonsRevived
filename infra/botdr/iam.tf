resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.env}-botdr-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_policy_assume.json
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "${var.env}-botdr-ecs-task-execution-policy"
  description = "Allows ECS tasks to call AWS services on your behalf."
  policy      = data.aws_iam_policy_document.ecs_task_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.env}-botdr-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume.json
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.env}-botdr-ecs-task-policy"
  description = "Allows ECS tasks to call AWS services on your behalf."
  policy      = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_policy" "ecs_task_policy_dev_player_pw" {
  count = var.env == "dev" ? 1 : 0

  name        = "${var.env}-botdr-ecs-task-policy-dev-player-pw"
  description = "Allows ECS tasks to call AWS services on your behalf."
  policy      = data.aws_iam_policy_document.ecs_task_role_policy_dev_player_pw[count.index].json
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_dev_player_pw_attachment" {
  count = var.env == "dev" ? 1 : 0

  policy_arn = aws_iam_policy.ecs_task_policy_dev_player_pw[count.index].arn
  role       = aws_iam_role.ecs_task_role.name
}
