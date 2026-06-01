provider "aws" {
  region = var.aws_region

}

resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = "aws-accelerator-phase-2"
    ManagedBy   = "Terraform"
  }
}