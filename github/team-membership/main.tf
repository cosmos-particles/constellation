resource "github_team_membership" "this" {
  for_each = merge([
    for team_id, members in var.team_members : {
      for username, role in members :
      "${team_id}:${username}" => {
        team_id  = team_id
        username = username
        role     = role
      }
    }
  ]...)

  team_id  = each.value.team_id
  username = each.value.username
  role     = each.value.role
}
