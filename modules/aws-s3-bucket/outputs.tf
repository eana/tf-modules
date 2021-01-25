output "bucket_ids" {
  description = "The ID of each bucket"
  value       = aws_s3_bucket.this.*.id
}

output "bucket_arns" {
  description = "ARN of each bucket"
  value       = aws_s3_bucket.this.*.arn
}

output "bucket_domain_names" {
  description = "Domain name of each bucket"
  value       = aws_s3_bucket.this.*.bucket_domain_name
}
