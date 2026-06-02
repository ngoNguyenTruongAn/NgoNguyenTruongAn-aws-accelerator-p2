terraform {
  backend "s3" {
    bucket       = "ngonguyentruongan-p2-tfstate"
    key          = "cloud/w8/day-a/mini-lab/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }

  required_version = ">=1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.47"
    }
  }
}