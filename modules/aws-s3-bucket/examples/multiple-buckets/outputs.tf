output "public_blocked_bucket_arns" {
  description = "ARN of the public blocked bucket"
  value       = module.private-bucket-public-block.bucket_arns
}

output "public_allow_bucket_arns" {
  description = "ARNs of the public allow buckets"
  value       = module.private-bucket-public-allow.bucket_arns
}
