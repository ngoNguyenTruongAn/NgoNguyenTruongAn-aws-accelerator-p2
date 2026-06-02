output "app_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = aws_s3_bucket.app.bucket
}

output "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
  value       = aws_s3_bucket.logs.bucket
}

output "app_bucket_arn" {
  description = "ARN of the application S3 bucket"
  value       = aws_s3_bucket.app.arn
}

output "logs_bucket_arn" {
  description = "ARN of the logs S3 bucket"
  value       = aws_s3_bucket.logs.arn
}

output "common_tags" {
  description = "Common tags applied to resources"
  value       = local.common_tags
}

output "secret_demo_value" {
  description = "Sensitive output demo. Terraform should hide this value."
  value       = var.secret_demo_value
  sensitive   = true
}