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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | The type of ACL to apply to the bucket | `string` | `"private"` | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket | `bool` | `true` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| mfa\_delete | Enable MFA delete on bucket objects | `bool` | `false` | no |
| names | A list of globally unique names for buckets | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| versioning | Enable versioning on bucket objects | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arns | ARN of each bucket |
| bucket\_domain\_names | Domain name of each bucket |
| bucket\_ids | The ID of each bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
