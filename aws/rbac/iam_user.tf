# IAMロールの作成
resource "aws_iam_role" "my_role" {
  name = "RbacDemoRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456780000:user/rbac-demo-user"
        }
      }
    ]
  })
}

# IAMポリシーの作成
resource "aws_iam_policy" "allow_assume_role_policy" {
  name        = "allow_assume_role_policy"
  path        = "/"
  description = "Allows user to assume role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = aws_iam_role.my_role.arn
      }
    ]
  })
}

# ロールへのポリシーの付与
resource "aws_iam_role_policy" "my_role_policy" {
  name   = "RbacDemoRolePolicy"
  role   = aws_iam_role.my_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "iam:ListRoles",
              "eks:*",
              "ssm:GetParameter"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

# IAMユーザーの作成
resource "aws_iam_user" "rbac_demo_user" {
  name = "rbac-demo-user"
}

# IAMポリシーをユーザーに関連付け
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = aws_iam_user.rbac_demo_user.name
  policy_arn = aws_iam_policy.allow_assume_role_policy.arn
}
