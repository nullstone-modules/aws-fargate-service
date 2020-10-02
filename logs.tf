resource "aws_cloudwatch_log_group" "this" {
  name = "/${var.env}/${var.block_name}"

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

module "lb_logs_bucket" {
  source  = "cloudposse/lb-s3-bucket/aws"
  version = "0.7.0"

  enabled = var.enable_lb

  name   = "${var.stack_name}-${var.env}-${var.block_name}"
  region = data.aws_region.this.name

  force_destroy = true

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}
