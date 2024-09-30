resource "aws_s3_bucket" "image_bucket" {
  bucket = "image-bucket"
  tags = {
    env = "int"
  }
}

