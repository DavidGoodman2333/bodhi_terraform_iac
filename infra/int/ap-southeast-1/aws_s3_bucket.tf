resource "aws_s3_bucket" "int_file_bucket" {
  bucket = "int_file_bucket"
  tags = {
    env = "int"
  }
}