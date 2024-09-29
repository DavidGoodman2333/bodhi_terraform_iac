resource "aws_s3_bucket" "file_bucket" {
  bucket = "file_bucket"
  tags = {
    env = "int"
  }
}

