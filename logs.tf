module "logs" {
  source = "nullstone-modules/logs/aws"

  name              = local.resource_name
  tags              = data.ns_workspace.this.tags
  enable_log_reader = true
}

locals {
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = data.aws_region.this.name
      "awslogs-group"         = module.logs.name
      "awslogs-stream-prefix" = local.block_name
    }
  }
  log_provider = "cloudwatch"
}
