# AWS MFA Terraform module

Terraform module to enforce MFA for AWS groups and users.

This module implements the instructions provided in the AWS Documentation:
[Enable Your Users to Configure Their Own Credentials and MFA
Settings](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_users-self-manage-mfa-and-creds.html).

## Usage

```tf

resource "aws_iam_group" "mfa_group" {
  name = "MFAGroup"
}

resource "aws_iam_user" "mfa_user" {
  name = "MFAUser"
}

module "aws-enforce-mfa" {
  source = "git::https://github.com/eana/aws-infra-tf.git//modules/enforce-mfa"
  groups = [aws_iam_group.mfa_group.name]
  users  = [aws_iam_user.mfa_user.name]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_password\_change\_without\_mfa | Allow changing the user password without MFA | `bool` | `false` | no |
| groups | Enforce MFA for the members in these groups | `list(string)` | `[]` | no |
| users | Enforce MFA for these users | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| force\_mfa\_policy\_arn | The ARN assigned by AWS to this policy. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
