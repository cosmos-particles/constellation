variable "cluster_name" {
  description = "Name of the EKS cluster these policies belong to. Every policy name is prefixed with \"$${cluster_name}-\" so policies are scoped to, and identifiable by, their owning cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "path" {
  description = "IAM path for the policies."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to every policy created by this module."
  type        = map(string)
  default     = {}
}
