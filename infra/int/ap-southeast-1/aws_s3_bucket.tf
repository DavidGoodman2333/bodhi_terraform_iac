resource "aws_s3_bucket" "file_bucket" {
  bucket = "file-bucket"
  tags = {
    env = "int"
  }
}

