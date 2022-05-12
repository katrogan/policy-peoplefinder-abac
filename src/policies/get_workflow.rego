package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false

allowed {
  # TODO: don't hardcode organization1
  # TODO: get organization from input.user when it's mapped from okta
  #some permission in res.get(input.resource.organization).organization1.projects[input.resource.project].permissions
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  # permission := {"action": "GET", "groups": ["group1"] }

  some permission in domain.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  input.resource.group == group
}

