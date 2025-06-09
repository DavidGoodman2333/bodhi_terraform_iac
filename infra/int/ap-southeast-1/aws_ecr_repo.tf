resource "aws_ecr_repository" "msccoin_frontend" {
  name = "msccoin_frontend"
}

resource "aws_ecr_repository" "msccoin_file_system" {
  name = "msccoin_file_system"
}