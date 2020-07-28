resource "aws_ecs_service" "this" {
  name            = var.block_name
  cluster         = data.aws_ecs_cluster.cluster.arn
  desired_count   = 1
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.cluster.outputs.private_subnet_ids
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
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
