terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "terraform-state-khoahoang"
    key    = "terraform-state-multi-region-recovery"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.primary_region
}

