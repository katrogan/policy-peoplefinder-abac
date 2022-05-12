# package flyteadmin.GET.api.v1.workflows
package flyteidl.service.AdminService.CreateWorkflowEvent

import future.keywords.in

default allowed = false

default global_perms_exist = false
default globally_allowed = false

default domain_perms_exist = false
default domain_allowed = false

default project_perms_exist = false
default project_allowed = false

default workflow_perms_exist = false
default workflow_allowed = false

has_key(x, k) { 
	_ = x[k]
}

# TODO: get organization and group from input.user when it's mapped from okta

global_perms_exist {
  res.get(input.resource.organization)[input.resource.organization].permissions
}

# Match global credentials.
globally_allowed {
  some permission in res.get(input.resource.organization)[input.resource.organization].permissions
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

domain_perms_exist {
  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  domain.permissions
}

# Match domain credentials.
domain_allowed {
  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  some permission in domain.permissions
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

project_perms_exist {
  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  project.permissions
}

project_allowed {
  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some permission in project.permissions
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

workflow_perms_exist {
  # If the intput resource doesn't specify a workflow then workflow permissions aren't even considered
  input.resource.workflow

  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some workflow in project.workflows
  workflow.permissions
}

workflow_allowed {
  some domain in res.get(input.resource.organization)[input.resource.organization].domains
  domain.name == input.resource.domain

  some project in domain.projects
  project.name == input.resource.project

  some workflow in project.workflows
  workflow.name == input.resource.workflow

  some permission in workflow.permissions
  some group in permission.groups
  some user_group in input.resource.groups
  user_group.name == group.name
}

# A decision is made when permissions are allowed (if configured) across all levels of the hierarchy
allowed {
  workflow_allowed
}

allowed {
  not workflow_perms_exist
  project_allowed
}

allowed {
  not workflow_perms_exist
  not project_perms_exist
  domain_allowed
}

allowed {
  not workflow_perms_exist
  not project_perms_exist
  not domain_perms_exist
  globally_allowed
}

allowed {
  not workflow_perms_exist
  not project_perms_exist
  not domain_perms_exist
  not global_perms_exist
}
