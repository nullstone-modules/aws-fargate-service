locals {
  min_capacity = try([for x in local.capabilities.auto_scaling : x.min_capacity if x.enabled][0], var.num_tasks)
  max_capacity = try([for x in local.capabilities.auto_scaling : x.max_capacity if x.enabled][0], var.num_tasks)
}

resource "aws_appautoscaling_target" "this" {
  min_capacity       = local.min_capacity
  max_capacity       = local.max_capacity
  resource_id        = "service/${local.cluster_name}/${local.block_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
