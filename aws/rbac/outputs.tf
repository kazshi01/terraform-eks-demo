output "my_role_arn" {
  description = "ARN of RbacDemoRole"
  value       = aws_iam_role.my_role.arn
}
