terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  env_id   = data.ns_workspace.this.env_id
}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags           = data.ns_workspace.this.tags
  block_name     = data.ns_workspace.this.block_name
  resource_name  = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
  is_preview_env = data.ns_env.this.type == "PreviewEnv"
}
