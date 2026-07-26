output "bucket_names" {
  value = aws_s3_bucket.random_bucket[*].bucket
}