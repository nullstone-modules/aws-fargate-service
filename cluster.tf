data "ns_connection" "cluster_namespace" {
  name     = "cluster-namespace"
  contract = "cluster-namespace/aws/ecs:*"
  optional = true
}

locals {
  has_namespace_conn = data.ns_connection.cluster_namespace.workspace_id != ""
}

data "ns_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/aws/ecs:fargate"
  // cluster is specified directly if cluster-namespace is unspecified
  via      = local.has_namespace_conn ? data.ns_connection.cluster_namespace.name : null
}

locals {
  service_domain       = local.has_namespace_conn ? data.ns_connection.cluster_namespace.outputs.namespace : data.ns_connection.network.outputs.service_discovery_name
  service_discovery_id = local.has_namespace_conn ? data.ns_connection.cluster_namespace.outputs.service_discovery_id : data.ns_connection.network.outputs.service_discovery_id
  cluster_arn          = data.ns_connection.cluster.outputs.cluster_arn
  cluster_name         = data.ns_connection.cluster.outputs.cluster_name
  deployers_name       = data.ns_connection.cluster.outputs.deployers_name
}
