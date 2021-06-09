module "logs" {
  source = "nullstone-modules/logs/aws"

  name              = local.resource_name
  tags              = data.ns_workspace.this.tags
  enable_log_reader = true
}
