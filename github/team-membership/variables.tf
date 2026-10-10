variable "team_members" {
  description = <<-EOT
    Map of team identifier => map of GitHub username => role ("member" or
    "maintainer"). Team identifier is whatever github_team_membership's team_id
    accepts: a team's numeric ID or its slug - a plain string, not a reference to
    any other module/resource. That's deliberate: this module has zero dependency
    on nebula/github/team or how/when a team was created, so it can run as its own
    Terraform root, against any existing team, independently of team creation.
  EOT
  type        = map(map(string))
  default     = {}
}
