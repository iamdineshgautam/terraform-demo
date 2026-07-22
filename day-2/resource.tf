data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  name = "my-security-group"
  description = "my-security-group"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
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

resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  disable_api_termination = false
  vpc_security_group_ids = [aws_security_group.id]
  user_data = file("/root/terraform-deo/day-2/user-data.sh")

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  } 

  tags = var.tags

}

