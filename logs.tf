module "logs" {
  source = "nullstone-modules/logs/aws"

  name              = local.resource_name
  tags              = data.ns_workspace.this.tags
  enable_log_reader = true
}

module "lb_logs_bucket" {
  source = "./lb_logs"

  name          = local.resource_name
  tags          = data.ns_workspace.this.tags
  force_destroy = true

  count = var.enable_lb ? 1 : 0
}
