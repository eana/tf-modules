Full Example
============

Configuration in this directory creates an ECR repository and policy by calling
the `aws-ecr` module.

A single ECR repository is created with a policy attachment allowing pull and
push access from the authenticated users.

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
