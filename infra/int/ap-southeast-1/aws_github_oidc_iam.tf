resource "aws_iam_role" "github-oidc-role" {
  name = "github-oidc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = ""
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::987595490691:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" : ["repo:avidGoodman2333/bodhi_terraform_iac:*"],
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

resource "aws_iam_role_policy" "github-oidc-role-policy" {
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