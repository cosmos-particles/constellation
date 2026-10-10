variable "org_settings" {
  description = <<-EOT
    Profile settings for an EXISTING GitHub organization. GitHub does not support
    creating a new organization via the standard API/GitHub App (only the web
    signup flow, or the GitHub Enterprise org-creation API), so this manages
    settings on an org that already exists.

    Leave null to skip managing org settings entirely (e.g. if another process
    owns the org profile and you only want this module to manage teams).

    IMPORTANT: because github_organization_settings is a singleton that fully
    controls the org profile, run `terraform import` against it before the
    first apply so Terraform doesn't overwrite settings it doesn't know about:
      terraform import github_organization_settings.this[0] <org-login>
  EOT
  type = object({
    billing_email                           = string
    company                                 = optional(string)
    description                             = optional(string)
    email                                   = optional(string)
    location                                = optional(string)
    name                                    = optional(string)
    default_repository_permission           = optional(string, "read")
    members_can_create_repositories         = optional(bool, false)
    members_can_create_public_repositories  = optional(bool, false)
    members_can_create_private_repositories = optional(bool, true)
    members_can_fork_private_repositories   = optional(bool, false)
  })
  default = null
}
