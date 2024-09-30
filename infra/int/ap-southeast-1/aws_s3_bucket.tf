resource "aws_s3_bucket" "bodhi_image_bucket" {
  bucket = "bodhi-image-bucket"
  tags = {
    env = "int"
  }
}

