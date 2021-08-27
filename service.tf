resource "aws_ecs_service" "this" {
  name            = local.block_name
  cluster         = data.aws_ecs_cluster.cluster.arn
  desired_count   = var.service_count
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.ns_connection.network.outputs.private_subnet_ids
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
    for_each = lookup(local.capabilities, "load_balancers", [])

    content {
      container_name   = local.block_name
      container_port   = load_balancer.value.port
      target_group_arn = load_balancer.value.target_group_arn
    }
  }
}

resource "aws_service_discovery_service" "this" {
  count = var.service_port == 0 ? 0 : 1

  name = local.block_name

  dns_config {
    namespace_id = data.ns_connection.network.outputs.service_discovery_id

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
