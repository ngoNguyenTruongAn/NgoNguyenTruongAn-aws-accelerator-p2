locals {
  name_prefix      = "${var.project_name}-${var.environment}"
  app_bucket_name  = "${local.name_prefix}-${var.app_bucket_suffix}"
  logs_bucket_name = "${local.name_prefix}-${var.logs_bucket_suffix}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
    Lab         = "W8-D1-S3-Backend-Locking"
  }

}