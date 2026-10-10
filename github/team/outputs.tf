output "team_ids" {
  description = "Map of team name => numeric team ID."
  value       = { for name, team in github_team.this : name => team.id }
}

output "team_slugs" {
  description = "Map of team name => team slug (used by github_team_repository, github_team_membership, etc.)."
  value       = { for name, team in github_team.this : name => team.slug }
}
