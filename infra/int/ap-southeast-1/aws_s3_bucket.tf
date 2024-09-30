resource "aws_s3_bucket" "bodhi_image_bucket" {
  bucket = "bodhi-image-bucket"
  tags = {
    env = "int"
  }
}

resource "aws_s3_bucket" "bodhi_file_bucket" {
  bucket = "bodhi-file-bucket"
  tags = {
    env = "int"
  }
}
