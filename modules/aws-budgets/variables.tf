## VARIABLES
## ----------------------------------------------------------------------------
variable "limit_amount" {
  type        = number
  description = "The budget limit amount"
}

variable "limit_unit" {
  type        = string
  description = "The budget limit unit. Default is USD"
  default     = "USD"
}

variable "subscriber_email_addresses" {
  type        = list(string)
  description = "The list of email addresses of notification subscribers"
  default     = []
}
