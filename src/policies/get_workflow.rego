package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false

allowed {
  # TODO: don't hardcode organization1
  # TODO: get organization from input.user when it's mapped from okta
  #some permission in res.get(input.resource.organization).organization1.projects[input.resource.project].permissions

  input.resource.action == "GET" 
  #input.resource.group in permission.groups
}

