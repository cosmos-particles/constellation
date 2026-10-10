variable "teams" {
  description = <<-EOT
    Map of team name => config. Creates the team only - no members. See
    nebula/github/team-membership to add members once a team exists; that's a
    separate module (and typically a separate Terraform root/state) on purpose,
    so adding/removing members never has to touch team creation.
  EOT
  type = map(object({
    description = optional(string)
    privacy     = optional(string, "closed")
  }))
  default = {}
}
