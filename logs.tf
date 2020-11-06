resource "aws_cloudwatch_log_group" "this" {
  name = "/${data.ns_workspace.this.env}/${data.ns_workspace.this.block}"

  tags = data.ns_workspace.this.tags
}

module "lb_logs_bucket" {
  source  = "cloudposse/lb-s3-bucket/aws"
  version = "0.7.0"

  enabled = var.enable_lb

  name   = data.ns_workspace.this.hyphenated_name
  region = data.aws_region.this.name

  force_destroy = true

  tags = data.ns_workspace.this.tags
}
