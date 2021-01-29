output "force_mfa_policy_arn" {
  value       = aws_iam_policy.force_mfa.arn
  description = "The ARN assigned by AWS to this policy."
}
