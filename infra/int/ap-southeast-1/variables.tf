variable "backend_bucket" {
  description = "The name of the S3 bucket for Terraform backend"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to assume"
  type        = string
}