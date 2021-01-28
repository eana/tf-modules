provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    aws = { version = ">= 3.21.0" }
  }
}

module "budgets" {
  source                     = "../"
  limit_amount               = "50"
  limit_unit                 = "USD"
  subscriber_email_addresses = ["jonas@eana.ro"]
}
