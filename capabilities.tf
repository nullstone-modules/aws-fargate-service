// This file is replaced by code-generation using 'capabilities.tf.tmpl'
locals {
  capabilities = {
    security_group_rules = [
      {
        id       = ""
        protocol = "tcp"
        port     = 0
      }
    ]

    env = [
      {
        name  = ""
        value = ""
      }
    ]

    secrets = [
      {
        name      = ""
        valueFrom = ""
      }
    ]

    load_balancers = [
      {
        port             = 80
        target_group_arn = ""
      }
    ]

    log_configurations = [
      {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = data.aws_region.this.name
          "awslogs-group"         = module.logs.name
          "awslogs-stream-prefix" = data.ns_workspace.this.env_name
        }
      }
    ]
  }
}
