<!-- vim: set ft=markdown: -->
# AWS ECR Module

#### Table of contents

<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Versions](#versions)
* [Usage](#usage)
* [Examples](#examples)
* [Inputs](#inputs)
* [Outputs](#outputs)

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

## Inputs

| Name             | Description                                                                   | Type   | Default                          |
|------------------|-------------------------------------------------------------------------------|--------|----------------------------------|
| create           | Conditionally create repository/policy                                        | bool   | `false`                          |
| name             | Name for identifying the repository.                                          | string | None                             |
| policy           | ECR policy to be attached to the repository                                   | string | None                             |
| lifecycle_policy | ECR Lifecycle policy to be attached to the repository                         | string | `local.default_lifecycle_policy` |
| scan_image       | Should the images uploaded be scanned by AWS ECR for security vulnerabilities | bool   | `true`                           |

## Outputs

| Name                       | Description                                      |
|----------------------------|--------------------------------------------------|
| ecr_repository_arn         | Full ARN of the repository                       |
| ecr_repository_name        | The name of the repository                       |
| ecr_repository_registry_id | The registry ID where the repository was created |
| ecr_repository_url         | The URL of the repository                        |