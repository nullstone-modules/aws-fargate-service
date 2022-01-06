terraform {
  required_providers {
    ns = {
      source  = "nullstone-io/ns"
      version = "~> 0.3"
    }
  }
}

data "ns_workspace" "this" {}

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
  tags                 = data.ns_workspace.this.tags
  cluster_name         = data.ns_connection.cluster.outputs.cluster_name
  deployers_name       = data.ns_connection.cluster.outputs.deployers_name
  service_domain       = data.ns_connection.network.outputs.service_discovery_name
  service_discovery_id = data.ns_connection.network.outputs.service_discovery_id
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = local.cluster_name
}
