package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false


# TODO: get organization and group from input.user when it's mapped from okta

# Match global credentials.
allowed {
  # TODO: don't hardcode organization1
  some permission in res.get(input.resource.organization).organization1.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# Match domain credentials.
allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some permission in domain.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# Match project credentials.
allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some permission in project.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# Match workflow credentials.
allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some workflow in project.workflows
  workflow.name == input.resource.workflow

  some permission in workflow.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}
