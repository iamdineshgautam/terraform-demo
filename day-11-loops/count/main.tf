resource "aws_instance" "my_instance" {
  ami = "ami-00d2dbb426772b03a"
  instance_type = "t3.micro"
  key_name = "u-key"
  count = 5
  tags = {
    Name = "my-instance"
  }
}