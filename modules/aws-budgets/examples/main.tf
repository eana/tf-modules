provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    aws = { version = ">= 3.21.0" }
  }
}

module "budgets" {
  source                     = "s3::https://s3-eu-west-1.amazonaws.com/tf-modules-prod/aws-budgets/aws-budgets-0.1.0.tar.gz"
  limit_amount               = "50"
  limit_unit                 = "USD"
  subscriber_email_addresses = ["jonas@eana.ro"]
}
