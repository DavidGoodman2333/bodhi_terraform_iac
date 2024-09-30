
variable "role_arn" {
  description = "The ARN of the IAM role to assume"
  type        = string
  default     = "arn:aws:iam::476114114107:role/github-oidc-role"
}