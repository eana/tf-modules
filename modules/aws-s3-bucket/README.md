AWS S3 Bucket Module
====================

Terraform module that can create a single or multiple AWS S3 buckets.  By
default this module will create private buckets.

This module creates the following resources:
* [S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [S3 Bucket Public Access Block](https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html)

Versions
--------

Terraform:  `>= 0.12`

Provider: `>= 2.21.1`

Usage
-----
```hcl
module "bucket" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/tf-modules/aws-s3-bucket/aws-s3-bucket-0.1.0.tar.gz"

  names      = ["my-unique-bucket-name"]
  versioning = true
  mfa_delete = true
}
```

Examples
--------
* [Multiple Buckets](./examples/multiple-buckets)

Inputs
------

| Name | Description | Type | Default |
|------|-------------|------|---------|
| acl | The type of ACL to apply to the bucket | string | `"private"` |
| block_public_acls | Whether Amazon S3 should block public ACLs for this bucket | bool | `true` |
| block_public_policy | Whether Amazon S3 should block public bucket policies for this bucket | bool | `true` |
| ignore_public_acls | Whether Amazon S3 should ignore public ACLs for this bucket | bool | `true` |
| mfa_delete | Enable MFA delete on bucket objects | bool | `false` |
| names | A list of globally unique names for buckets | list |`[""]` |
| restrict_public_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket | bool | `true` |
| versioning | Enable versioning on bucket objects | bool | `false` |

Outputs
-------
| Name | Description |
|------|-------------|
| bucket_arns | ARN of each bucket |
| bucket_domain_names | Domain name of each bucket |
| bucket_ids | The ID of each bucket |
