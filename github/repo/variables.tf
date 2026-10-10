variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  type    = string
  default = null
}

variable "visibility" {
  description = <<-EOT
    One of "public", "private", or "internal". Defaults to "public" - branch
    protection rules (github_branch_protection) require GitHub Pro/Team/Enterprise
    on a private repo, so public is the default that works out of the box on a
    free org. Set to "private" per-repo if you have the plan for it.
  EOT
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "visibility must be one of: public, private, internal."
  }
}

variable "topics" {
  type    = list(string)
  default = []
}

variable "default_branch" {
  description = "Branch to set as the repository's default. Applied after creation via github_branch_default."
  type        = string
  default     = "main"
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "allow_merge_commit" {
  type    = bool
  default = false
}

variable "allow_squash_merge" {
  type    = bool
  default = true
}

variable "allow_rebase_merge" {
  type    = bool
  default = false
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "vulnerability_alerts" {
  description = <<-EOT
    When true, creates a github_repository_vulnerability_alerts resource to enable
    Dependabot alerts. When false, no such resource is created, so Terraform doesn't
    manage this setting either way (it won't force it off - it's simply left alone).
  EOT
  type        = bool
  default     = true
}

variable "branch_protection" {
  description = "Branch protection rule for default_branch. Leave null to skip."
  type = object({
    pattern                         = optional(string, "main")
    required_approving_review_count = optional(number, 1)
    require_code_owner_reviews      = optional(bool, false)
    required_status_checks          = optional(list(string), [])
    enforce_admins                  = optional(bool, false)
    require_conversation_resolution = optional(bool, true)
  })
  default = null
}

variable "team_access" {
  description = "Map of team slug => permission (pull, triage, push, maintain, admin)."
  type        = map(string)
  default     = {}
}

variable "collaborators" {
  description = "Map of GitHub username => permission, for individuals outside any team."
  type        = map(string)
  default     = {}
}
