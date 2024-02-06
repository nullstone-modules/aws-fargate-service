// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  cap_modules = [
    {
      id         = 0
      namespace  = ""
      env_prefix = ""
      outputs    = {}
    }
  ]

  cap_env_vars = {}
  cap_secrets  = {}

  capabilities = {
    env = [
      {
        name  = ""
        value = ""
      }
    ]

    secrets = [
      {
        name  = ""
        value = ""
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
        url = ""
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        url = ""
      }
    ]

    log_configurations = [
      {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = data.aws_region.this.name
          "awslogs-group"         = module.logs.name
          "awslogs-stream-prefix" = local.block_name
        }
      }
    ]

    // capabilities can attach mount points to pull/push data from/to the main container
    // The name of each mount point will be added to the task as a volume, then mounted in the main container
    mount_points = [
      {
        name = "volume-name"
        path = "/path/on/main/disk"
      }
    ]

    // sidecars allow capabilities to attach additional containers to the service
    sidecars = [
      {
        name         = ""
        image        = ""
        essential    = false
        portMappings = [{ protocol = "tcp", containerPort = 0, hostPort = 0 }]
        environment  = [{ name = "", value = "" }]
        secrets      = [{ name = "", valueFrom = "" }]
        mountPoints  = [{ sourceVolume = "", containerPath = "" }]
        volumesFrom  = [{ sourceContainer = "" }]
        dependsOn    = [{ containerName = "", condition = "" }]
      }
    ]

    // events allow capabilities to attach event targets
    // The app module expects the capability to create the event rule and role and export it
    // The app module will use information about the app, cluster, and network to create event targets
    events = [
      {
        rule_name = ""
        role_arn  = ""
        input     = "{}"
      }
    ]

    // metrics allows capabilities to attach metrics to the application
    // These metrics are displayed on the Application Monitoring page
    // See https://docs.nullstone.io/extending/metrics/aws-cloudwatch.html#metrics-mappings
    metrics = [
      {
        name = ""
        type = "usage|usage-percent|duration|generic"
        unit = ""

        mappings = "{}"
      }
    ]
  }
}
