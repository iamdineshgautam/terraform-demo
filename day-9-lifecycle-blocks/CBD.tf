# provider "aws" {
#   region = "ap-south-1"
#   profile = "dev"
# }

# resource "aws_instance" "ec2" {
#   ami = "ami-00d2dbb426772b03a"
#   instance_type = "t3.micro"
#   tags = {
#     Name = "ec2_instance"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }


