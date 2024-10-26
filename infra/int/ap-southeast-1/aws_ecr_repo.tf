resource "aws_ecr_repository" "bodhi_frontend" {
  name = "bodhi_frontend"
}

resource "aws_ecr_repository" "bodhi_file_system" {
  name = "bodhi_file_system"
}