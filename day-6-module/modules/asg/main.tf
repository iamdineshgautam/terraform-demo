resource "aws_launch_template" "lt" {
  name_prefix = "my-lt"
  image_id = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
  name = "my_asg"
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  target_group_arns = [var.target_arn]
  vpc_zone_identifier = [var.public_subnet_1,var.public_subnet_2]
  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }
}