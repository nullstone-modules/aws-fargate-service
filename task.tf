locals {
  main_container_name = "main"

  container_definition = {
    name      = local.main_container_name
    image     = "${local.service_image}:${local.app_version}"
    essential = true
    portMappings = [for port, obj in local.all_port_mappings : {
      protocol      = "tcp"
      containerPort = tonumber(port)
      hostPort      = tonumber(port)
    }]

    environment = [for k, v in local.all_env_vars : { name = k, value = v }]
    secrets     = local.secret_refs

    mountPoints = local.mount_points
    volumesFrom = []

    logConfiguration = local.log_configuration
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.resource_name
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  depends_on               = [aws_iam_role_policy.execution]
  container_definitions    = jsonencode(concat([local.container_definition], local.addl_container_defs))
  tags                     = local.tags
  task_role_arn            = aws_iam_role.task.arn

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage > 20 ? [var.ephemeral_storage] : []

    content {
      size_in_gib = ephemeral_storage.value
    }
  }

  dynamic "volume" {
    for_each = local.volumes

    content {
      name = volume.key

      dynamic "efs_volume_configuration" {
        for_each = length(volume.value.efs_volume) > 0 ? tomap({ "1" = jsondecode(volume.value.efs_volume) }) : tomap({})

        content {
          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = efs_volume_configuration.value.root_directory
          transit_encryption      = "ENABLED"
          transit_encryption_port = 2999
        }
      }
    }
  }
}

resource "aws_iam_role" "task" {
  name               = "task-${local.resource_name}"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

data "aws_iam_policy_document" "task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "task" {
  role   = aws_iam_role.task.id
  name   = local.resource_name
  policy = data.aws_iam_policy_document.task.json
}

data "aws_iam_policy_document" "task" {
  statement {
    sid       = "AllowSSH"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
  }
}
