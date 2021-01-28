Multiple Buckets
================

Configuration in this directory creates three S3 buckets by calling the
`aws-s3-bucket` module twice.

A single private bucket with public access unavailable as an option and
versioning enabled, is created in the first module call;
`private-bucket-public-block`.

Two private buckets with the potential to allow public access are created in
the second module call; `private-bucket-public-allow`.

Usage
-----
To run this example you need to execute the following, where `AWS-PROFILE` is
the target AWS profile you wish to use:
```bash
$ terraform init
$ terraform plan -var 'profile=AWS-PROFILE'
$ terraform apply -var 'profile=AWS-PROFILE'
```

To destroy this example you need to execute the following:
```bash
$ terraform destroy -var 'profile=AWS-PROFILE'
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.21.1 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| profile | Local AWS profile to use | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_allow\_bucket\_arns | ARNs of the public allow buckets |
| public\_blocked\_bucket\_arns | ARN of the public blocked bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
