data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg"{
    name = "my-security-group"
    description = "Security group for ALB and instances"
    vpc_id = data.aws_vpc.default.id

    ingress{
        from_port = var.ingress_ssh
        to_port = var.ingress_ssh
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.ingress_http
        to_port = var.ingress_http
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "my-security-group"
    }
}

resource "aws_lb_target_group" "tg" {
    name = "web-tg"
    port = var.tg_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
    }
}

resource "aws_lb" "lb" {
    name = "my-alb"
    internal = false
    load_balancer_type = var.load_balancer_type
    security_groups = [aws_security_group.sg.id]
    subnets = [
        subnet-06c107ffba913397d, 
        subnet-0935759f8f9f39e11
    ]
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.lb.arn
    port = var.tg_port
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}

resource "aws_launch_template" "lt" {
    name = "web-launch-template"
    image_id = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_group_ids = [aws_security_group.sg.id]

    user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
    name = "my-asg"
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    launch_template {
        id = aws_launch_template.lt.id
        version = var.lt_version
    }

    target_group_arns = [aws_lb_target_group.tg.arn]
    vpc_zone_identifier = [
        data.aws_subnet.default.id,
        data.aws_subnet.default.id
    ]
}

