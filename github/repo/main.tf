resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility
  topics      = var.topics

  # When we're pushing our own initial content, don't let GitHub auto-create a
  # competing first commit - our push becomes the first commit instead.
  auto_init = var.push_initial_content == null

  has_issues   = var.has_issues
  has_wiki     = var.has_wiki
  has_projects = var.has_projects

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  vulnerability_alerts = var.vulnerability_alerts
}

resource "null_resource" "push_initial_content" {
  count = var.push_initial_content != null ? 1 : 0

  # Keyed on repo_id so this only runs once, at creation - re-applies never
  # re-push and silently overwrite content someone has since committed upstream.
  triggers = {
    repo_id = github_repository.this.repo_id
  }

  provisioner "local-exec" {
    command = join(" ", [
      "${path.module}/scripts/push-initial-content.sh",
      "'${var.push_initial_content.source_path}'",
      "'${github_repository.this.http_clone_url}'",
      "'${var.default_branch}'",
      "'${var.push_initial_content.commit_message}'",
    ])
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch

  depends_on = [null_resource.push_initial_content]
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
