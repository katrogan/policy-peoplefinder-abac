package flyteadmin.GET.api.v1.workflows

import future.keywords.in

default allowed = false

default globally_allowed = false
default domain_allowed = false
default project_allowed = false
default workflow_allowed = false

# TODO: get organization and group from input.user when it's mapped from okta

# Match global credentials.
globally_allowed {
  # TODO: don't hardcode organization1
  some permission in res.get(input.resource.organization).organization1.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# Match domain credentials.
# - when no domain permissions are set
domain_allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  permissions_exist = has_key(domain, "permissions")
  not permissions_exist
}

# - when a matching domain permission is set
domain_allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some permission in domain.permissions
  input.resource.action == permission["action"]
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# Match project credentials.
# - when no project permissions are set
project_allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  permissions_exist = has_key(project, "permissions")
  not permissions_exist
}

# - when a matching project permission is set
project_allowed {
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
# - the resource doesn't exist at the per-workflow level.
workflow_allowed {
  is_workflow_scoped = haskey(input.resource, "workflow")
}

# - when no workflow permissions are set
workflow_allowed {
  some domain in res.get(input.resource.organization).organization1.domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some workflow in project.workflows
  workflow.name == input.resource.workflow

  permissions_exist = has_key(workflow, "permissions")
  not permissions_exist
}

workflow_allowed {
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

# A decision is made when permissions are allowed across all levels of the hierarchy
allowed {
  globally_allowed
  domain_allowed
  project_allowed
  workflow_allowed  
}
