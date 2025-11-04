// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  cap_modules = [
    {
      name       = ""
      tfId       = ""
      namespace  = ""
      env_prefix = ""
      outputs    = {}

      meta = {
        subcategory = ""
        platform    = ""
        subplatform = ""
        outputNames = []
      }
    }
  ]

  // cap_env_prefixes is a map indexed by tfId which points to the env_prefix in local.cap_modules
  cap_env_prefixes = tomap({
    x = ""
  })

  capabilities = {
    env = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    secrets = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = sensitive("")
      }
    ]

    load_balancers = [
      {
        cap_tf_id        = ""
        port             = 80
        target_group_arn = ""
      }
    ]

    metric_alarms = [
      {
        cap_tf_id           = ""
        type                = ""
        name                = ""
        comparison_operator = ""
        evaluation_periods  = ""
        metric_name         = ""
        namespace           = ""
        period              = 0
        statistic           = ""
        threshold           = 0
        alarm_description   = ""
        actions             = jsonencode([])
      }
    ]

    auto_scaling = [
      {
        cap_tf_id    = ""
        enabled      = false
        min_capacity = 1
        max_capacity = 1
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        cap_tf_id = ""
        url       = "https://example"
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        cap_tf_id = ""
        url       = "https://example.com"
      }
    ]

    log_configurations = [
      {
        cap_tf_id = ""
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = data.aws_region.this.region
          "awslogs-group"         = module.logs.name
          "awslogs-stream-prefix" = local.block_name
        }
      }
    ]

    // capabilities can attach mount points to pull/push data from/to the main container
    // The name of each mount point will be added to the task as a volume, then mounted in the main container
    mount_points = [
      {
        cap_tf_id = ""
        name      = "volume-name"
        path      = "/path/on/main/disk"
      }
    ]

    volumes = [
      {
        name = ""
        efs_volume = jsonencode({
          file_system_id = ""
          root_directory = ""
        })
      }
    ]

    // sidecars allow capabilities to attach additional containers to the service
    sidecars = [
      {
        cap_tf_id    = ""
        name         = ""
        image        = ""
        essential    = false
        portMappings = jsonencode([{ protocol = "tcp", containerPort = 0, hostPort = 0 }])
        environment  = jsonencode([{ name = "", value = "" }])
        secrets      = jsonencode([{ name = "", valueFrom = "" }])
        mountPoints  = jsonencode([{ sourceVolume = "", containerPath = "" }])
        volumesFrom  = jsonencode([{ sourceContainer = "" }])
        dependsOn    = jsonencode([{ containerName = "", condition = "" }])
      }
    ]

    // events allow capabilities to attach event targets
    // The app module expects the capability to create the event rule and role and export it
    // The app module will use information about the app, cluster, and network to create event targets
    events = [
      {
        cap_tf_id = ""
        rule_name = ""
        role_arn  = ""
        input     = "{}"
      }
    ]

    // ulimits allow capabilities to modify ulimits on the main container
    ulimits = [
      {
        cap_tf_id = ""
        name      = "" // "core"|"cpu"|"data"|"fsize"|"locks"|"memlock"|"msgqueue"|"nice"|"nofile"|"nproc"|"rss"|"rtprio"|"rttime"|"sigpending"|"stack"
        softLimit = 0  // integer
        hardLimit = 0  // integer
      }
    ]

    linux_parameters = [
      {
        initProcessEnabled = false
      }
    ]

    // metrics allows capabilities to attach metrics to the application
    // These metrics are displayed on the Application Monitoring page
    // See https://docs.nullstone.io/extending/metrics/aws-cloudwatch.html#metrics-mappings
    metrics = [
      {
        cap_tf_id = ""
        name      = ""
        type      = "usage|usage-percent|duration|generic"
        unit      = ""

        mappings = jsonencode({})
      }
    ]
  }
}
