terraform {
  required_version = ">= 0.12"
}

resource "aws_s3_bucket" "this" {
  count = "${length(var.names)}"

  bucket = var.names[count.index]
  acl    = var.acl

  versioning {
    enabled    = var.versioning
    mfa_delete = var.mfa_delete
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  depends_on = ["aws_s3_bucket.this"]
  count      = "${length(var.names)}"

  bucket                  = aws_s3_bucket.this[count.index].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
