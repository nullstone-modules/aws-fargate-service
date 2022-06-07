terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags          = data.ns_workspace.this.tags
  block_name    = data.ns_workspace.this.block_name
  resource_name = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
}

data "ns_connection" "cluster" {
  name = "cluster"
  type = "cluster/aws-fargate"
}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
  via  = data.ns_connection.cluster.name
}

locals {
  vpc_id               = data.ns_connection.network.outputs.vpc_id
  private_cidrs        = data.ns_connection.network.outputs.private_cidrs
  public_cidrs         = data.ns_connection.network.outputs.public_cidrs
  cluster_name         = data.ns_connection.cluster.outputs.cluster_name
  deployers_name       = data.ns_connection.cluster.outputs.deployers_name
  service_domain       = data.ns_connection.network.outputs.service_discovery_name
  service_discovery_id = data.ns_connection.network.outputs.service_discovery_id
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = local.cluster_name
}
