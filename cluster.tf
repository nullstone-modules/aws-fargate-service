data "ns_connection" "cluster_namespace" {
  name     = "cluster-namespace"
  contract = "cluster-namespace/aws/ecs:*"
}

data "ns_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/aws/ecs:fargate"
  via      = data.ns_connection.cluster_namespace.name
}

locals {
  service_domain       = data.ns_connection.cluster_namespace.outputs.namespace
  service_discovery_id = data.ns_connection.cluster_namespace.outputs.service_discovery_id
  cluster_arn          = data.ns_connection.cluster.outputs.cluster_arn
  cluster_name         = data.ns_connection.cluster.outputs.cluster_name
  deployers_name       = data.ns_connection.cluster.outputs.deployers_name
}
