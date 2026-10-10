variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  type    = string
  default = null
}

variable "visibility" {
  description = "One of \"public\", \"private\", or \"internal\"."
  type        = string
  default     = "private"

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
  description = "Branch to set as the repository's default. Applied after creation (and after push_initial_content, if set) via github_branch_default."
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
  type    = bool
  default = true
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

variable "push_initial_content" {
  description = <<-EOT
    If set, pushes the contents of source_path (an absolute local directory,
    expected to already be a git working tree) to the repo's default branch
    as its initial commit, using scripts/push-initial-content.sh. Requires
    GITHUB_APP_ID/GITHUB_APP_INSTALLATION_ID/GITHUB_APP_PEM_FILE (or GITHUB_TOKEN)
    in the environment the Terraform process runs in.
  EOT
  type = object({
    source_path    = string
    commit_message = optional(string, "Initial commit")
  })
  default = null
}
