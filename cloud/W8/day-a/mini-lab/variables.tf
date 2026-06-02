variable "aws_region" {
  description = "AWS region used for this Terraform lab"
  type        = string
}

variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name, for example dev, staging, prod"
  type        = string
}

variable "owner" {
  description = "Owner name for resource tagging"
  type        = string
}

variable "app_bucket_suffix" {
  description = "Unique suffix for the app S3 bucket"
  type        = string
}

variable "logs_bucket_suffix" {
  description = "Unique suffix for the logs S3 bucket"
  type        = string
}

variable "secret_demo_value" {
  description = "Demo secret value to prove sensitive variable usage"
  type        = string
  sensitive   = true
}