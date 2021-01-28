variable "names" {
  description = "A list of globally unique names for buckets"
  type        = list(string)
  default     = [""]
}

variable "acl" {
  description = "The type of ACL to apply to the bucket"
  default     = "private"
}

variable "versioning" {
  description = "Enable versioning on bucket objects"
  type        = bool
  default     = false
}

variable "mfa_delete" {
  description = "Enable MFA delete on bucket objects"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true

}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}
