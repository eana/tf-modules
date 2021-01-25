# Terraform Modules

<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Usage](#usage)
    * [Updating Modules](#updating-modules)
    * [Calling Modules](#calling-modules)
* [Repository Structure](#repository-structure)
    * [modules/](#modules)
    * [tmp/](#tmp)
    * [tools/](#tools)
        * [package.sh](#packagesh)
        * [upload.sh](#uploadsh)
* [Versioning](#versioning)
* [Module Style Guide](#module-style-guide)
    * [Naming](#naming)
    * [Structure](#structure)
        * [README.md (Required)](#readmemd-required)
        * [main.tf (Required)](#maintf-required)
        * [outputs.tf (Required)](#outputstf-required)
        * [variables.tf (Required)](#variablestf-required)
        * [version.txt (Required)](#versiontxt-required)
        * [examples/ (Optional)](#examples-optional)
    * [Note](#note)
* [Deprecating a Module](#deprecating-a-module)
    * [1. Remove Code and Mark as Deprecated](#1-remove-code-and-mark-as-deprecated)
    * [2. Merge Pull Request to push deprecated module version to Artifactory](#2-merge-pull-request-to-push-deprecated-module-version-to-artifactory)
    * [3. Remove remaining module directories and files](#3-remove-remaining-module-directories-and-files)
* [Further Reading](#further-reading)
* [Useful Links](#useful-links)

<!-- vim-markdown-toc -->

## Overview

This repo contains configuration for Terraform modules. These modules can be
called by Terraform configuration and used to manage resources in a standard
way. When working with Terraform, the *DRY* (Don't Repeat Yourself) principle
should be used where possible. Terraform modules aid with this.

The modules contained within this repo are versioned and **should not be
referenced directly**. Module configurations contained pass through the CI
system where, upon successful build, will generate a versioned module tarball
(gzipped) and stored in a S3 bucket.

When designating a module source in your Terraform configuration, reference the
tarball archive stored in S3 that represents the version you require.
Terraform supports various archive formats for modules.

## Usage

### Updating Modules

1. Before creating or updating a module, please ensure that you are familiar
   with the [style guide](#module-style-guide) and follow the documented
   recommendations
2. Create your module or update an existing module as required. If you are
   creating a new module, ensure that you have included a `version.txt` file in
   the root of your module containing the text `0.1.0`. If updating an existing
   module, bump the contents of `version.txt` appropriately according to the
   type of update. See the [Versioning section](#versioning) below for more
   information.
3. Create your pull request

### Calling Modules

1. In your Terraform configuration code (sometimes referred to as *glue code*),
reference the desired module version in Artifact as the source. Example:

```hcl
module "mymodule" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/tf-modules/my-module/my-module-0.1.0.tar.gz"
}
```
2. If referenced correctly, a local copy of the module will be downloaded when
`terraform init` is run

## Repository Structure

```bash
tf-modules
├── modules
│   └── my-module
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── version.txt
├── tmp
└── tools
    ├── package.sh
    └── upload.sh
```
### modules/
Individual module directories are stored within the `modules` directory along
with the subsequent version and Terraform files.

### tmp/
A directory required by the CI process. Contents are not tracked by Git.

### tools/
Contains scripts used during the build process.

#### package.sh
Bash script which verifies module versioning, then packages modules contained
within the `modules` directory into tarballs, ready for upload to S3.

#### upload.sh
Bash script which verifies the existence of module tarballs in S3 and uploads
new tarballs.

## Versioning

`version.txt` is required and must be updated every time a pull request is to
be created. The CI system will read the version contained within the file and
create a module tarball based on the contents during the build process. We use
[Semantic Versioning](https://semver.org/) for Terraform modules.

Versioning solves a key issue when working with Terraform modules. When storing
and referencing modules directly from GitHub in a single repository we run the
risk of unexpected changes to configurations when modules are updated. A
Terraform module can and should be referenced by multiple configurations to
reduce repeated code. However, when multiple configurations reference a module
the configurations adhere to the current state of the module master branch.

As modules evolve, changes might be implemented that suit one particular
configuration but could break others. Versioning allows us to ensure that when
a module is updated, only configurations that reference the new version are
affected and there are no unexpected changes to any others.

The only contents of `version.txt` should be the semantic version of the module
(example: `1.2.3`). Depending on the type of change being made to the module,
the MAJOR, MINOR or PATCH version should be incremented by one by the author
pre pull request.

Examples:

* A change to a module introduces breaking changes, `1.0.0` should be
incremented to `2.0.0`
* A change to a module adds backwards-compatible features, `1.0.0` should be
incremented to `1.1.0`
* A change to a module fixes a bug or syntactical error, `1.0.0` should be
incremented to `1.0.1`

**If the module version is not incremented for each PR the build will fail.**

## Module Style Guide

### Naming
Given the wide range of [providers](https://www.terraform.io/docs/providers/)
that Terraform supports it makes sense to append the name of the provider to
the name of the module for easy identification and grouping. Follow the naming
format `provider-service`.

Example:
```bash
modules
├── aws-ecs
├── aws-eks
├── aws-vpc
├── gcp-big-table
├── gcp-dns
├── github-repository
└── heroku-app
```

### Structure

The way in which a module is structured can vary depending on the complexity.
There are however key practices that should be followed when organising module
structure.

#### README.md (Required)

Every module must have a `README.md` at its root. It should include:
* Overview of the module purpose
* List of resources that can be created by the module
* Provider version constraints
* Description of optional attributes
* Links to any examples
* A table naming and describing supported variables (including expected type
  and default value)
* A table naming and describing supported outputs
* Instructions for running any tests

#### main.tf (Required)

The body of the module is contained within the `main.tf`. All resource
declarations along with their arguments live here.

Example:
```hcl
resource "aws_vpc" "this" {
  cidr_block          = var.vpc_cidr
  instance_tenancy    = var.instance_tenancy
  enable_dns_hostname = var.enable_dns_hostnames
  enable_dns_support  = var.enable_dns_support

  tags = {
      Name        = var.tag_vpc_name,
      Environment = var.tag_env
  }
}
```

#### outputs.tf (Required)

Any values that need to be displayed post-apply or passed to another part of
the configuration are defined in `outputs.tf`. Each output declaration must
have both the `description` and `value` attribute.

Example:
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

```

#### variables.tf (Required)

Variables should be declared separately from the body of the module. Those
variables can then be referenced by Terraform resources. Every variable must
contain a `description`, a `default` value, and if not a string, a `type`.

Example:
```hcl
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tag_vpc_name" {
  description = "Name of VPC"
  default     = ""
}

variable "tag_env" {
  description = "Environment name"
  default     = "test"
}
```

#### version.txt (Required)

File containing the incremental semantic version of the module.

#### examples/ (Optional)

Including example Terraform configuration that utilises the module not only
provides guidance for how to use the model but can also be used in automated
testing in conjunction with packages such as
[Terratest](https://github.com/gruntwork-io/terratest).

### Note

At times it may be necessary for additional files to be included within the
module. These could be bash scripts, user-data text, or IAM policies in JSON
format, etc. These additional files should be stored in a suitable directory
within the module. Group similar files within the same directory. For example
you may want to include all AWS policy documents in a `policies/` directory and
all EC2 user-data in `user-data/`.

## Deprecating a Module

This describes the steps needed to deprectate a module. This should be done to
ensure that modules that are no longer required are cleaned up to reduce any
confusion as to whether a module is in use and valid.

### 1. Remove Code and Mark as Deprecated

The first step is to remove all the enclosed code for the module but update the
`version.txt`. This is to have the latest version of the module to be marked as
deprecated. This makes it clear for users.

The only files remaining after this step should be:

- `version.txt` (bumping the version number)
- `README.md` (with an explicit note saying the module has been deprecated

### 2. Merge Pull Request to push deprecated module version to Artifactory

Merging the PR that marks the module as deprecated kicks off the CI workflow to
create a new artifact with the latest module version.

### 3. Remove remaining module directories and files

Create a 2nd PR that removes the remaining module directory, including its
`version.txt` and `README.md`.

## Further Reading

* [Learn Terraform](https://learn.hashicorp.com/terraform)
* [Terraform Modules](https://www.terraform.io/docs/configuration/modules.html)
* [Reusable Infrastructure with Terraform Modules](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d)

## Useful Links

* [HashiCorp Terraform Module Registry](https://registry.terraform.io/)
