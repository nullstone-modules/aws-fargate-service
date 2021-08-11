// This file is replaced by code-generation using 'capabilities.tf.tmpl'
locals {
  capabilities = {
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

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        value = ""
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        value = ""
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
