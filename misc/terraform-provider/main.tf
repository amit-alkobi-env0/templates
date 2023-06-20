locals {
  api_endpoint    = "https://pr12252.dev.env0.com"
  env0_api_key    = ""
  env0_api_secret = ""
  project_name    = "Many workflows"
}

terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

provider "env0" {
  api_key      = local.env0_api_key
  api_secret   = local.env0_api_secret
  api_endpoint = local.api_endpoint
}

data "env0_organization" "my_organization" {}

output "organization_name" {
  value = data.env0_organization.my_organization.name
}

data "env0_project" "default_project" {
  name = local.project_name
}

resource "env0_template" "workflow-template" {
  name                   = "null"
  description            = "A Workflow with error"
  repository             = "https://github.com/tomer-landesman/templates"
  path                   = "workflow"
  type                   = "workflow"
  ssh_keys               = []
  github_installation_id = 24858980
}

resource "env0_template" "null_template_1" {
  name        = "subenv1"
  description = "Sub Env 1"
  repository  = "https://github.com/tomer-landesman/templates"
  path        = "misc"
  type        = "terraform"
}

resource "env0_template" "null_template_2" {
  name        = "subenv2"
  description = "Sub Env 2"
  repository  = "https://github.com/tomer-landesman/templates"
  path        = "misc"
  type        = "terraform"
}

resource "env0_template" "null_template_3" {
  name        = "subenv3"
  description = "Sub Env 3"
  repository  = "https://github.com/tomer-landesman/templates"
  path        = "misc"
  type        = "terraform"
}

resource "env0_template_project_assignment" "assignment" {
  template_id = env0_template.workflow-template.id
  project_id  = data.env0_project.default_project.id
}

resource "env0_template_project_assignment" "assignment2" {
  template_id = env0_template.null_template_2.id
  project_id  = data.env0_project.default_project.id
}

resource "env0_template_project_assignment" "assignment3" {
  template_id = env0_template.null_template_1.id
  project_id  = data.env0_project.default_project.id
}

resource "env0_template_project_assignment" "assignment4" {
  template_id = env0_template.null_template_3.id
  project_id  = data.env0_project.default_project.id
}

resource "env0_environment" "wf-env" {
  depends_on = [
    env0_template_project_assignment.assignment,
    env0_template_project_assignment.assignment2,
    env0_template_project_assignment.assignment3,
    env0_template_project_assignment.assignment4,
  ]
  name                       = "workflow-provider"
  project_id                 = data.env0_project.default_project.id
  template_id                = env0_template.workflow-template.id
  force_destroy              = true
  approve_plan_automatically = true
}
