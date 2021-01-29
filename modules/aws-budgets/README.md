<!-- vim: set ft=markdown: -->

# terraform-aws-budgets

#### Table of contents
<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [AWS Budgets](#aws-budgets)
    * [Resources docs](#resources-docs)
    * [Example](#example)

<!-- vim-markdown-toc -->
## Overview

A Terraform module to deploy custom AWS budgets. It is used to resource create,
replace, or delete budgets for Billing and Cost Management. For more
information, see [Managing Your Costs with
Budgets](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/budgets-managing-costs.html)
in the AWS Billing and Cost Management User Guide.

Terraform >= 0.12.0 is required for this module.

## AWS Budgets

### Resources docs

AWS Budgets automation includes the use of the following core Terraform
resources:

- [`aws_budgets_budget`](https://www.terraform.io/docs/providers/aws/r/budgets_budget.html)
  - Provides a budgets budget resource.

### Example

A simple example:

```tf
module "budgets" {
  source                     = "s3::https://s3-eu-west-1.amazonaws.com/tf-modules/aws-budgets/aws-budgets-0.1.0.tar.gz"
  limit_amount               = 100
  limit_unit                 = "USD"
  subscriber_email_addresses = ["jonas@eana.ro"]
}
```

To apply that:

```text
terraform apply
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
| limit\_amount | The budget limit amount | `number` | n/a | yes |
| limit\_unit | The budget limit unit. Default is USD | `string` | `"USD"` | no |
| subscriber\_email\_addresses | The list of email addresses of notification subscribers | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| budget\_id | The id of the budget. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
