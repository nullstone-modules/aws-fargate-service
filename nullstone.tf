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

data "aws_ecs_cluster" "cluster" {
  cluster_name = data.ns_connection.cluster.outputs.cluster_name
}

locals {
  deployer_name = data.ns_connection.cluster.outputs.deployer["name"]
}
