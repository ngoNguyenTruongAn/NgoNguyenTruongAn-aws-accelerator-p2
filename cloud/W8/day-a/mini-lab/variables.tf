variable "aws_region" {
  description = "AWS region for Terraform resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  description = "Name of the demo S3 bucket"
  type        = string
  default     = "ngonguyentruongan-w8-d1-terraform-demo-20260601"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}