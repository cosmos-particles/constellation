output "memberships" {
  description = "Map of \"<team_id>:<username>\" => role, for every membership this module manages."
  value       = { for k, m in github_team_membership.this : k => m.role }
}
