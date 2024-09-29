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
    role_arn                = "arn:aws:iam::476114114107:role/github-oidc-role"
    session_name            = "terraform-infra-provision-session"
    web_identity_token_file = "/tmp/web_identity_token"
  }
}