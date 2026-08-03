provider "aws" {
  region = "ap-south-1"
  profile = "dev"
}

resource "aws_s3_bucket" "s3" {
  bucket = "deploywithdinesh.space"

  tags = {
    Name = "dinesh.space"
  }

  lifecycle {
    prevent_destroy = true
  }
}