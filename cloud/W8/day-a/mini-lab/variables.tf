variable "aws_region" {
  description = "AWS region for Terraform resources"
  type        = string
}

variable "bucket_name" {
  description = "Name of the demo S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}