terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "eu-west-1"
  version = ">= 2.21.1"
  profile = var.profile
}

module "private-bucket-public-block" {
  source = "../../"

  names      = ["my-private-s3-bucket-example"]
  versioning = true
}

module "private-bucket-public-allow" {
  source = "../../"

  names = [
    "my-public-s3-bucket-example-1",
    "my-public-s3-bucket-example-2"
  ]

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
