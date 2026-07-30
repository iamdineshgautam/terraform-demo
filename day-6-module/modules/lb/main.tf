resource "aws_lb_target_group" "lb_target_group" {
  name = "lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
  }
}

resource "aws_lb" "ALB" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.sg_id]
  subnets = [var.public_subnet_1_id, var.public_subnet_2_id]
  tags = {
    Name = "my-alb"
  }
}

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.ALB.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}