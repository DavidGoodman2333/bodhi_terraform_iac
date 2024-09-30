terraform {
  backend "s3" {
    bucket = "bodhi-terraform-backend"
    region = "ap-southeast-1"
    key    = "ap-southeast-1/state"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"

  assume_role_with_web_identity {
    role_arn                = var.role_arn
    session_name            = "terraform-infra-provision-session"
    web_identity_token_file = "/tmp/web_identity_token"
  }
}

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = {
    terraform-managed = true
    environment       = "int"
  }
}

data "aws_iam_role" "github-oidc-role" {
  name = "github-oidc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = ""
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::476114114107:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" : ["repo:DavidGoodman2333/bodhi_terraform_iac:*"],
          }

          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    terraform-managed = true
    environment       = "int"
  }
}

data "aws_iam_role_policy" "github-oidc-role-policy" {
  name = "github-oidc-role-policy"
  role = aws_iam_role.github-oidc-role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "",
        Action = [
          "ec2:*",
          "iam:*",
          "logs:*",
          "kms:*",
          "route53:*",
          "route53resolver:*",
          "acm:*",
          "ecr:*",
          "shield:*",
          "eks:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::bodhi-terraform-backend/*"
      },
      {
        Sid = "",
        Action = [
          "s3:*",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::*"
      }
    ]
  })

}