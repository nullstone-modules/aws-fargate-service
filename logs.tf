resource "aws_cloudwatch_log_group" "this" {
  name = "/${data.ns_workspace.this.env}/${data.ns_workspace.this.block}"

  tags = data.ns_workspace.this.tags
}

module "lb_logs_bucket" {
  source = "./lb_logs"

  count = var.enable_lb ? 1 : 0

  name          = data.ns_workspace.this.hyphenated_name
  tags          = data.ns_workspace.this.tags
  force_destroy = true
}
