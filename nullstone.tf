terraform {
  required_providers {
    ns = {
      source  = "nullstone-io/ns"
      version = "~> 0.3"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_app_env" "this" {
  app   = data.ns_workspace.this.block
  stack = data.ns_workspace.this.stack
  env   = data.ns_workspace.this.env
}

locals {
  app_version = data.ns_app_env.this.version
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

data "ns_connection" "mesh" {
  name     = "mesh"
  type     = "mesh/aws"
  optional = true
}

data "ns_connection" "subdomain" {
  name     = "subdomain"
  type     = "subdomain/aws"
  optional = true
}

data "ns_connection" "postgres" {
  name     = "postgres"
  type     = "postgres/aws-rds"
  optional = true
}

locals {
  db_user_security_group_id = try(data.ns_connection.postgres.outputs.db_user_security_group_id, "")
  cert_arn                  = try(data.ns_connection.subdomain.outputs.cert_arn, "")
  subdomain_zone_id         = try(data.ns_connection.subdomain.outputs.zone_id, "")
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = data.ns_connection.cluster.outputs.cluster_name
}

data "aws_iam_role" "execution" {
  name = data.ns_connection.cluster.outputs.cluster_execution_role_name
}
