resource "aws_ecs_service" "this" {
  name            = var.block_name
  cluster         = data.aws_ecs_cluster.cluster.arn
  desired_count   = 1
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.network.outputs.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }

  dynamic "load_balancer" {
    for_each = var.enable_lb ? [aws_lb_target_group.this.arn] : []

    content {
      target_group_arn = load_balancer.value
      container_name   = var.block_name
      container_port   = 80
    }
  }

  depends_on = [aws_lb_listener.http, aws_lb_listener.https]
}

resource "aws_lb_target_group" "this" {
  name                 = "${var.stack_name}-${var.env}-${var.block_name}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.network.outputs.vpc_id
  deregistration_delay = 30

  health_check {
    // TODO: Enable later
    enabled = false
  }

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_service_discovery_service" "this" {
  name = var.block_name

  dns_config {
    namespace_id = data.terraform_remote_state.cluster.outputs.service_discovery_id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }

  // This is necessary to cause ecs service to transition from ACTIVATING to RUNNING
  // See https://forums.aws.amazon.com/thread.jspa?threadID=283572
  health_check_custom_config {
    failure_threshold = 1
  }
}
