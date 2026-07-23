output "public_ip" {
  value = aws_instance.public_instance.public_ip
}

output "sg_id" {
  value = aws_security_group.my-sg.id
}

output "instance_id" {
  value = aws_instance.public_instance.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}