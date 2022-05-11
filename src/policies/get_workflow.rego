package flyteadmin.GET.api.v1.workflows

default allowed = false

allowed {
  # TODO: don't hardcode organization1
  input.group in res.get(input.organization).organization1.projects[input.project].actions[input.action]
}

