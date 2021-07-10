resource "aws_ecs_service" "this" {
  name            = data.ns_workspace.this.block_name
  cluster         = data.aws_ecs_cluster.cluster.arn
  desired_count   = 1
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.ns_connection.network.outputs.private_subnet_ids
    assign_public_ip = false
    security_groups  = compact([aws_security_group.this.id, local.db_user_security_group_id])
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }

  dynamic "load_balancer" {
    for_each = try(local.capabilities.load_balancers, [])

    content {
      container_name   = data.ns_workspace.this.block_name
      container_port   = load_balancer.value.port
      target_group_arn = load_balancer.value.target_group_arn
    }
  }

  depends_on = [module.load_balancer]
}

resource "aws_service_discovery_service" "this" {
  name = data.ns_workspace.this.block_name

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
