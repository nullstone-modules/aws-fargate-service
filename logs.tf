resource "aws_cloudwatch_log_group" "this" {
  name = local.resource_name
  tags = data.ns_workspace.this.tags
}

module "lb_logs_bucket" {
  source = "./lb_logs"

  name          = local.resource_name
  tags          = data.ns_workspace.this.tags
  force_destroy = true

  count = var.enable_lb ? 1 : 0
}
