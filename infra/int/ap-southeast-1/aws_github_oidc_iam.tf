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
            "token.actions.githubusercontent.com:sub" : ["repo:AveDex/ave-terraform-iac:*", "repo:AveDex/ave-flink-applications:*", "repo:AveDex/ave_solana_etl:*", "repo:AveDex/ave_inscription_monitor:*", "repo:AveDex/ave2_kline_recording:*", "repo:AveDex/solana_event_parser:*", "repo:AveDex/ave2_token_price:*", "repo:AveDex/akka-http-middleware:*", "repo:AveDex/ave_evm_etl:*", "repo:AveDex/ave_evm_event_parser:*", "repo:AveDex/ave_sol_etl_supplement:*"],
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
    environment       = "prod"
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
        Resource = "arn:aws:s3:::ave-terraform-backend/*"
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