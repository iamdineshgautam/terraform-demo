resource "random_id" "bucket_suffix" {
  count = var.bucket_count
  byte_length = 4
}

resource "aws_s3_bucket" "random_bucket" {
  count = var.bucket_count
  bucket = "deploywithdinesh-${random_id.bucket_suffix[count.index].hex}"

  tags = {
    Name = "dinesh-${count.index + 1}"
  }
}