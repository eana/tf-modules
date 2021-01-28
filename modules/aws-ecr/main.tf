terraform {
  required_version = ">= 0.12"
}

resource "aws_ecr_repository" "this" {
  count = var.create ? 1 : 0
  name  = var.name
  tags  = merge(local.default_tags, var.tags)

  image_scanning_configuration {
    scan_on_push = var.scan_image
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.create ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = var.policy
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.create ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = var.lifecycle_policy == "" ? local.default_lifecycle_policy : var.lifecycle_policy
}
