package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false

allowed {
  # TODO: don't hardcode organization1
  some permission in res.get(input.organization).organization1.projects[input.project].permissions

  input.action == permission.action 
  input.group in permission.groups
}

