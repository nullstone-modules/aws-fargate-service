locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })

  main_container_name = "main"

  // has_port_mapping dictates whether the main container should map a port to the network
  // If the user specifies service_port=0, then that will disable
  // If a capability sidecar specifies as owns_service_port=true, then that will also disable
  disable_main_port_mapping = !(var.service_port > 0) || anytrue(values(local.sidecars_owns_service_port))

  env_vars = [for k, v in merge(local.standard_env_vars, var.service_env_vars) : { name = k, value = v }]

  container_definition = {
    name      = local.main_container_name
    image     = "${local.service_image}:${local.app_version}"
    essential = true
    portMappings = local.disable_main_port_mapping ? [] : [
      {
        protocol      = "tcp"
        containerPort = var.service_port
        hostPort      = var.service_port
      }
    ]

    environment = concat(local.env_vars, try(local.capabilities.env, []))
    secrets     = local.app_secrets

    mountPoints = local.mount_points
    volumesFrom = []

    logConfiguration = local.log_configuration
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
  container_definitions    = jsonencode(concat([local.container_definition], local.addl_container_defs))
  tags                     = data.ns_workspace.this.tags

  dynamic "volume" {
    for_each = local.volumes

    content {
      name = volume.key
    }
  }
}
