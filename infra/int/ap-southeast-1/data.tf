data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy" "aws_managed_ecr_power_user_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy" "aws_managed_ecr_full_access" {
  arn = "arn:aws:iam::aws:policy/amazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "aws_managed_s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "aws_managed_read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "aws_ec2_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}