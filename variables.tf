variable "location" {
  type        = string
  description = <<EOT
    (Optional) The location where the resources will be deployed.

    Default: australiaeast
  EOT
  default     = "australiaeast"
}

variable "environment" {
  type        = string
  description = <<EOT
    (Optional) The environment for the Landing Zone.

    Options:
    - dev
    - uat
    - prd

    Default: dev
  EOT
  default     = "dev"

  validation {
    condition = contains(
      ["dev", "uat", "prd"],
      var.environment
    )
    error_message = "Err: the environment passed in is not valid."
  }
}

variable "project" {
  type        = string
  description = <<EOT
    (Required) An acronym/identifier for the landing zone.
  EOT

  validation {
    condition     = length(var.project) <= 4
    error_message = "Err: project identifier cannot be longer that four characters."
  }
}

variable "tags" {
  type        = map(string)
  description = <<EOT
    (Optional) Standard set of tags to apply to all resources.

    Default: {}
  EOT
  default     = {}
}
