resource "aws_ecs_service" "this" {
  // The name of the service determines the internal DNS name (i.e. <service-name>.<dns-namespace>)
  name                              = local.block_name
  tags                              = local.tags
  propagate_tags                    = "SERVICE"
  cluster                           = local.cluster_arn
  desired_count                     = var.num_tasks
  task_definition                   = aws_ecs_task_definition.this.arn
  launch_type                       = "FARGATE"
  enable_execute_command            = true
  health_check_grace_period_seconds = length(local.cap_load_balancers) > 0 ? var.health_check_grace_period : null

  network_configuration {
    subnets          = local.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
  }

  dynamic "service_registries" {
    for_each = aws_service_discovery_service.this

    content {
      registry_arn = service_registries.value.arn
    }
  }

  dynamic "load_balancer" {
    for_each = local.cap_load_balancers

    content {
      container_name   = local.lb_container_name
      container_port   = load_balancer.value.port
      target_group_arn = load_balancer.value.target_group_arn
    }
  }
}

resource "aws_service_discovery_service" "this" {
  count = var.port == 0 ? 0 : 1

  name = local.block_name

  dns_config {
    namespace_id = local.service_discovery_id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
