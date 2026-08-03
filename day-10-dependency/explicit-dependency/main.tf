resource "aws_instance" "ec2" {
  ami = ""
  instance_type = "t3.micro"
  depends_on = [  ]
  tags = {
    Name = "ec2_instance"
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "deploywithdinesh.space"
  tags = {
    Name = "deploywithdinesh.space"
  }
}