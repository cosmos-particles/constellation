variable "cluster_name" {
  description = "Name of the EKS cluster this role belongs to. The role name is always prefixed with \"$${cluster_name}-\" so roles are scoped to, and identifiable by, their owning cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "name" {
  description = "Suffix appended after \"$${cluster_name}-\" to form the IAM role name."
  type        = string
}

variable "path" {
  description = "IAM path for the role."
  type        = string
  default     = "/"
}

variable "trusted_service_principals" {
  description = "AWS service principals allowed to assume this role, e.g. [\"eks.amazonaws.com\"]."
  type        = list(string)
}

variable "assume_role_actions" {
  description = "STS actions granted to the trusted principals, e.g. [\"sts:AssumeRole\", \"sts:TagSession\"]."
  type        = list(string)
  default     = ["sts:AssumeRole"]
}

variable "source_account_id" {
  description = "AWS account ID to require via the aws:SourceAccount trust-policy condition. Prevents a confused-deputy scenario where an EKS cluster in a different account could assume this role. Leave null to skip this restriction."
  type        = string
  default     = null
}

variable "source_arns" {
  description = "ARN patterns (supports wildcards) to require via the aws:SourceArn trust-policy condition, e.g. [\"arn:aws:eks:*:111122223333:cluster/$${cluster_name}\"]. Restricts assumption to the named cluster only. Leave empty to skip this restriction."
  type        = list(string)
  default     = []
}

variable "policy_arns" {
  description = "IAM policy ARNs (AWS-managed or customer-managed) to attach to this role, keyed by a stable logical name. A map (rather than a list) is required so the attachment keys are known at plan time even when the ARN values are not yet known, e.g. when attaching policies created in the same apply."
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Whether to create an IAM instance profile for the role. Required for roles assumed by EC2 instances (e.g. node group roles); not needed for service-assumed roles like the EKS cluster role."
  type        = bool
  default     = false
}

variable "permissions_boundary_arn" {
  description = "ARN of the IAM policy to use as the permissions boundary for the role."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) for the role."
  type        = number
  default     = 3600
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
