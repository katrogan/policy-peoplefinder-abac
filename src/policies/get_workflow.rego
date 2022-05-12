package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false

# Match domain credentials.
allowed {
  # TODO: don't hardcode organization1
  # TODO: get organization from input.user when it's mapped from okta
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some permission in domain.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  input.resource.group == group
}

# Match project credentials.
allowed {
  # TODO: don't hardcode organization1
  # TODO: get organization from input.user when it's mapped from okta
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some permission in project.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  input.resource.group == group
}
