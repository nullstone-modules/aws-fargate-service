locals {
  events = merge([for cp in local.cap_modules : { for i, event in lookup(cp.outputs, "events", []) : "cap_${cp.tfId}_${i}" => event }]...)

  # Strip the trailing ':<revision>' so event targets resolve to the latest ACTIVE revision at invocation time.
  # The deployer registers a new task definition revision and deregisters the previous one on every deploy;
  # pinning a specific revision here would leave event targets pointing at a deregistered (INACTIVE) revision.
  task_definition_family_arn = replace(aws_ecs_task_definition.this.arn, "/:\\d+$/", "")
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
    task_definition_arn    = local.task_definition_family_arn
    launch_type            = "FARGATE"
    enable_execute_command = true

    network_configuration {
      subnets          = local.private_subnet_ids
      assign_public_ip = false
      security_groups  = [aws_security_group.this.id]
    }
  }
}
