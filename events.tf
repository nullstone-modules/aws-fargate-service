locals {
  events = { for event in lookup(local.capabilities, "events", []) : event.rule_name => event }
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = local.events

  rule     = each.value.rule_name
  role_arn = each.value.role_arn
  arn      = local.cluster_arn
  input    = each.value.input

  ecs_target {
    tags                   = local.tags
    task_count             = 1
    task_definition_arn    = aws_ecs_task_definition.this.arn
    launch_type            = "FARGATE"
    enable_execute_command = true

    network_configuration {
      subnets          = local.private_subnet_ids
      assign_public_ip = false
      security_groups  = [aws_security_group.this.id]
    }
  }
}
