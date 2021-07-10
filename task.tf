locals {
  env_vars = [for k, v in var.service_env_vars : { name = k, value = v }]

  log_configurations = concat(try(local.capabilities.log_configurations, []), [{
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = data.aws_region.this.name
      "awslogs-group"         = module.logs.name
      "awslogs-stream-prefix" = data.ns_workspace.this.env_name
    }
  }])

  container_definition = {
    name      = data.ns_workspace.this.block_name
    image     = "${local.service_image}:${local.app_version}"
    essential = true
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.service_port
        hostPort      = var.service_port
      }
    ]

    environment = concat(local.env_vars, try(local.capabilities.env, []))
    secrets     = local.capabilities.secrets

    cpu               = var.service_cpu
    memoryReservation = var.service_memory

    mountPoints = []
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
  container_definitions    = jsonencode([local.container_definition])
  tags                     = data.ns_workspace.this.tags
}
