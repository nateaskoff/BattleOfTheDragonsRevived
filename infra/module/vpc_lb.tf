resource "aws_lb" "app_lb_primary" {
  #checkov:skip=CKV_AWS_152:no x-zone required
  #checkov:skip=CKV_AWS_91:don't need access logging
  #checkov:skip=CKV_AWS_150
  #checkov:skip=CKV2_AWS_28
  name                       = "${lower(var.app_name)}-botdr-lb-primary"
  internal                   = false
  load_balancer_type         = "network"
  drop_invalid_header_fields = true

  subnets = [
    aws_subnet.app_subnet_public.id
  ]
}

resource "aws_lb_target_group" "app_lb_target_group_primary" {
  name        = "${lower(var.app_name)}-botdr-lb-tg-ec2"
  port        = 5121
  protocol    = "UDP"
  vpc_id      = aws_vpc.app_vpc_primary.id
  target_type = "instance"

  health_check {
    enabled = true
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener" "app_lb_listener_primary" {
  default_action {
    target_group_arn = aws_lb_target_group.app_lb_target_group_primary.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.app_lb_primary.arn
  port              = 5121
  protocol          = "UDP"
}

resource "aws_lb_target_group_attachment" "app_lb_tg_att" {
  target_group_arn = aws_lb_target_group.app_lb_target_group_primary.arn
  target_id        = aws_instance.app_ec2_primary.id
  port             = 5121
}
