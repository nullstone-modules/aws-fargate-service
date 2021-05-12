locals {
  env_vars = [for k, v in var.service_env_vars : map("name", k, "value", v)]

  logConfiguration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = data.aws_region.this.name
      "awslogs-group"         = aws_cloudwatch_log_group.this.name
      "awslogs-stream-prefix" = data.ns_workspace.this.env
    }
  }

  container_definition = {
    name              = data.ns_workspace.this.block
    image             = "${local.service_image}:${local.app_version}"
    essential         = true
    logConfiguration  = local.logConfiguration
    cpu               = var.service_cpu
    memoryReservation = var.service_memory
    environment       = local.env_vars
    mountPoints       = []
    volumesFrom       = []

    dependsOn = local.has_mesh ? [{
      containerName = "envoy"
      condition     = "HEALTHY"
    }] : []

    portMappings = [
      {
        protocol      = "tcp"
        containerPort = 80
        hostPort      = 80
      }
    ]
  }

  container_defs = compact([
    local.container_definition,
    local.has_mesh ? local.mesh_container_definition : null,
    local.has_mesh && var.enable_xray ? local.xray_container_definition : null
  ])
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.resource_name
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.execution.arn
  container_definitions    = jsonencode(local.container_defs)
  tags                     = data.ns_workspace.this.tags

  dynamic "proxy_configuration" {
    for_each = local.has_mesh ? [1] : []

    content {
      container_name = "envoy"
      type           = "APPMESH"

      properties = {
        AppPorts         = 80
        EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
        IgnoredUID       = "1337"
        ProxyEgressPort  = 15001
        ProxyIngressPort = 15000
      }
    }
  }
}
