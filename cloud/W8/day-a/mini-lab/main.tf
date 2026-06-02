resource "aws_s3_bucket" "logs" {
  bucket = local.logs_bucket_name

  tags = merge(local.common_tags, {
    Name = local.logs_bucket_name
    Role = "logs"
  })
}

resource "aws_s3_bucket" "app" {
  bucket = local.app_bucket_name

  tags = merge(local.common_tags, {
    Name = local.app_bucket_name
    Role = "app"
  })
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "app_to_logs" {
  bucket = aws_s3_bucket.app.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "app-access-logs/"

  depends_on = [
    aws_s3_bucket_versioning.logs,
    aws_s3_bucket_server_side_encryption_configuration.logs
  ]
}

resource "aws_s3_bucket" "imported_demo" {
  bucket = "ngonguyentruongan-p2-import-demo"

  tags = merge(local.common_tags, {
    Name = "ngonguyentruongan-p2-import-demo"
    Role = "import-demo"
  })
}