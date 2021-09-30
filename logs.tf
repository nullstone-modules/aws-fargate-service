module "logs" {
  source = "nullstone-modules/logs/aws"

  name              = local.resource_name
  tags              = data.ns_workspace.this.tags
  enable_log_reader = true
}

locals {
  cw_log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = data.aws_region.this.name
      "awslogs-group"         = module.logs.name
      "awslogs-stream-prefix" = local.block_name
    }
  }

  cap_log_configurations = lookup(local.capabilities, "log_configurations", [])
  addl_log_configurations = [for lc in local.cap_log_configurations : {
    logDriver     = lc.logDriver
    options       = jsondecode(lookup(lc, "options", "{}"))
    secretOptions = jsondecode(lookup(lc, "secretOptions", "{}"))
  }]

  log_configurations = concat(local.addl_log_configurations, [local.cw_log_configuration])

  log_secret_option_arns = [for so in lookup(local.log_configurations[0], "secretOptions", []) : so.valueFrom]
}
