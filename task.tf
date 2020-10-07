locals {
  env_vars = [for k, v in var.service_env_vars : map("name", k, "value", v)]

  container_definition = {
    name  = var.block_name
    image = "${aws_ecr_repository.this.repository_url}:${var.service_image_tag}"
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = 80
        hostPort      = 80
      }
    ]

    environment = local.env_vars

    cpu               = var.service_cpu
    memoryReservation = var.service_memory

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-region"        = data.aws_region.this.name
        "awslogs-group"         = aws_cloudwatch_log_group.this.name
        "awslogs-stream-prefix" = var.env
      }
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.stack_name}-${var.env}-${var.block_name}"
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.execution.arn
  container_definitions    = jsonencode([local.container_definition])

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}
