locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })

  main_container_name = "main"

  env_vars = [for k, v in merge(local.standard_env_vars, var.service_env_vars) : { name = k, value = v }]

  log_configurations = concat(try(local.capabilities.log_configurations, []), [{
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = data.aws_region.this.name
      "awslogs-group"         = module.logs.name
      "awslogs-stream-prefix" = local.block_name
    }
  }])

  container_definition = {
    name      = local.main_container_name
    image     = "${local.service_image}:${local.app_version}"
    essential = true
    portMappings = var.service_port == 0 ? [] : [
      {
        protocol      = "tcp"
        containerPort = var.service_port
        hostPort      = var.service_port
      }
    ]

    environment = concat(local.env_vars, try(local.capabilities.env, []))
    secrets     = local.app_secrets

    cpu               = var.service_cpu
    memoryReservation = var.service_memory

    mountPoints = local.mount_points
    volumesFrom = []

    logConfiguration = local.log_configurations[0]
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.resource_name
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  depends_on               = [aws_iam_role_policy.execution]
  container_definitions    = jsonencode([local.container_definition])
  tags                     = data.ns_workspace.this.tags

  dynamic "volume" {
    for_each = local.volumes

    content {
      name = volume.key
    }
  }
}
