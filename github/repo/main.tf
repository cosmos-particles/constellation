resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility
  topics      = var.topics

  # Let GitHub create the first commit (e.g. a README) - developers push their
  # own content afterwards using their own credentials, not this module.
  auto_init = true

  has_issues   = var.has_issues
  has_wiki     = var.has_wiki
  has_projects = var.has_projects

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
}

# Separate resource rather than github_repository's own (now-deprecated)
# vulnerability_alerts argument - absence of this resource just means
# Terraform doesn't manage the setting, it doesn't force it off.
resource "github_repository_vulnerability_alerts" "this" {
  count = var.vulnerability_alerts ? 1 : 0

  repository = github_repository.this.name
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch_protection" "this" {
  count = var.branch_protection != null ? 1 : 0

  repository_id = github_repository.this.name
  pattern       = var.branch_protection.pattern

  required_pull_request_reviews {
    required_approving_review_count = var.branch_protection.required_approving_review_count
    require_code_owner_reviews      = var.branch_protection.require_code_owner_reviews
  }

  dynamic "required_status_checks" {
    for_each = length(var.branch_protection.required_status_checks) > 0 ? [var.branch_protection.required_status_checks] : []
    content {
      strict   = true
      contexts = required_status_checks.value
    }
  }

  enforce_admins                  = var.branch_protection.enforce_admins
  require_conversation_resolution = var.branch_protection.require_conversation_resolution

  depends_on = [github_branch_default.this]
}

resource "github_team_repository" "this" {
  for_each = var.team_access

  team_id    = each.key
  repository = github_repository.this.name
  permission = each.value
}

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}
