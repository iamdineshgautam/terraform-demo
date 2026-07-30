output "dns_name" {
  value = aws_lb.ALB.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}
