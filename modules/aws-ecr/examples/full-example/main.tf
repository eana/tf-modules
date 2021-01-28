provider "aws" {
  version = "~> 2.13"
  region  = "eu-west-1"
}

locals {
  create = "${terraform.workspace == "default" ? true : false}"
}

module "example" {
  source = "../../"

  create           = "${local.create}"
  name             = "example"
  policy           = file("policies/ecr_policy.json")
  lifecycle_policy = file("lifecycle_policies/example.json")
}
