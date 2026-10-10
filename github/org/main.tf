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

resource "github_team" "this" {
  for_each = var.teams

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_team_membership" "this" {
  for_each = merge([
    for team_name, team in var.teams : {
      for username, role in team.members :
      "${team_name}:${username}" => {
        team_id  = github_team.this[team_name].id
        username = username
        role     = role
      }
    }
  ]...)

  team_id  = each.value.team_id
  username = each.value.username
  role     = each.value.role
}
