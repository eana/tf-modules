<!-- vim: set ft=markdown: -->
# AWS ECR Module

#### Table of contents

<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Versions](#versions)
* [Usage](#usage)
* [Examples](#examples)

<!-- vim-markdown-toc -->

## Overview

This module manages AWS ECR repositories and policy attachment.

This module creates the following resource:
* [ECR Repository](https://www.terraform.io/docs/providers/aws/r/ecr_repository.html)
* [ECR Repository Policy](https://www.terraform.io/docs/providers/aws/r/ecr_repository_policy.html)
* [ECR Repository Lifecycle Policy](https://www.terraform.io/docs/providers/aws/r/ecr_lifecycle_policy.html)

## Versions

Terraform: `>= 0.12`
Provider: `>= 2.13`

## Usage

Create an ECR repository and attach a policy:

```tf
module "example" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/tf-modules/aws-ecr/aws-ecr-0.1.0.tar.gz"

  create           = "${terraform.workspace == "prod" ? true : false}"
  name             = "example"
  policy           = file("policies/example_policy.json")
  lifecycle_policy = file("lifecycle_policies/example_lifecycle_policy.json")
}
```

## Examples

* [Full Example](./examples/full-example)

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
| create | Determine whether to create repository/policy | `bool` | `false` | no |
| lifecycle\_policy | Content of desired ECR lifecycle policy JSON file | `string` | `""` | no |
| name | Repository name | `string` | n/a | yes |
| policy | Content of desired ECR policy JSON file | `string` | n/a | yes |
| scan\_image | Should the images uploaded be scanned by AWS ECR for security vulnerabilities | `bool` | `true` | no |
| tags | Addional tags to be added to the ECR repository | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ecr\_repository\_arn | Full ARN of the repository |
| ecr\_repository\_name | The name of the repository |
| ecr\_repository\_registry\_id | The registry ID where the repository was created |
| ecr\_repository\_url | The URL of the repository |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
