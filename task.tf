resource "aws_ecs_task_definition" "this" {
  family                   = "${var.stack_name}-${var.block_name}-${var.env}"
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.execution.arn

  tags = {
    Stack       = var.stack_name
    Block       = var.block_name
    Environment = var.env
  }

  container_definitions = <<EOF
[
  {
    "name": "${var.block_name}",
    "image": "${aws_ecr_repository.this.repository_url}",
    "command": [],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "secrets": [],
    "environment": [],
    "essential": true,
    "cpu": ${var.service_cpu},
    "memoryReservation": ${var.service_memory},
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${data.aws_region.this.name}",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-stream-prefix": "${var.env}"
      }
    }
  }
]
EOF
}
