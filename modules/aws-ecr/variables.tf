variable "create" {
  type        = bool
  description = "Determine whether to create repository/policy"
  default     = false
}

variable "name" {
  type        = string
  description = "Repository name"
}

variable "policy" {
  type        = string
  description = "Content of desired ECR policy JSON file"
}

variable "tags" {
  type        = map(string)
  description = "Addional tags to be added to the ECR repository"
  default     = {}
}

variable "lifecycle_policy" {
  type        = string
  description = "Content of desired ECR lifecycle policy JSON file"
  default     = ""
}

variable "scan_image" {
  type        = bool
  description = "Should the images uploaded be scanned by AWS ECR for security vulnerabilities"
  default     = true
}
