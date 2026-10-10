resource "github_organization_settings" "this" {
  count = var.org_settings != null ? 1 : 0

  billing_email = var.org_settings.billing_email
  company       = var.org_settings.company
  description   = var.org_settings.description
  email         = var.org_settings.email
  location      = var.org_settings.location
  name          = var.org_settings.name

  default_repository_permission           = var.org_settings.default_repository_permission
  members_can_create_repositories         = var.org_settings.members_can_create_repositories
  members_can_create_public_repositories  = var.org_settings.members_can_create_public_repositories
  members_can_create_private_repositories = var.org_settings.members_can_create_private_repositories
  members_can_fork_private_repositories   = var.org_settings.members_can_fork_private_repositories
}
