locals {
  oidc_url = replace(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://", "")
}

resource "aws_iam_role" "irsa_iam_role" {
  name = "${var.cluster_name}-irsa-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_url}"
        }
        Condition = {
          StringEquals = {
            "${local.oidc_url}:aud" : "sts.amazonaws.com",
            "${local.oidc_url}:sub" : "system:serviceaccount:default:irsa-demo-sa"
          } ## namespace:default, serviceaccount:irsa-demo-sa
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.cluster_name}-irsa-iam-role"
  }
}

# Associate IAM Role and Policy
resource "aws_iam_role_policy_attachment" "irsa_iam_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.irsa_iam_role.name
}
