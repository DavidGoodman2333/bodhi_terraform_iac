resource "aws_iam_role" "image_reflector_controller" {
  name = "image-reflector-controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::476114114107:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/63F70535F3EBEB91D99661071E0DDAA4"
      }
      Condition = {
        StringEquals = {
          "oidc.eks.ap-southeast-1.amazonaws.com/id/63F70535F3EBEB91D99661071E0DDAA4:sub" = "system:serviceaccount:flux-system:image-reflector-controller"
        }
      }
    }
  })
}

data "aws_iam_policy" "aws_managed_ecr_readonly_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "tf_service_role_for_ecr_policy_attachment" {
  policy_arn = data.aws_iam_policy.aws_managed_ecr_readonly_policy.arn
  role       = aws_iam_role.image_reflector_controller.id
}