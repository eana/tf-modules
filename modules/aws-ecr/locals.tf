locals {
  default_tags = {
    created_by = "terraform"
  }
}

locals {
  default_lifecycle_policy = <<EOT
  {
    "rules": [
      {
        "action": {
          "type": "expire"
        },
        "selection": {
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 1,
          "tagStatus": "untagged"
        },
        "description": "Remove untagged images",
        "rulePriority": 5
      }
    ]
  }
  EOT
}
