resource "aws_appautoscaling_target" "this" {
  min_capacity       = var.num_tasks
  max_capacity       = var.max_tasks
  resource_id        = "service/${local.cluster_name}/${local.block_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
