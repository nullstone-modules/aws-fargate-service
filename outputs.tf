output "log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "repo_name" {
  value = aws_ecr_repository.this.name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "service_id" {
  value = aws_ecs_service.this.id
}

output "task_family" {
  value = aws_ecs_task_definition.this.family
}

output "service_security_group_id" {
  value = aws_security_group.this.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "cluster_block" {
  value = var.parent_blocks.cluster
}

output "network_block" {
  value = local.network_block
}

output "lb_arn" {
  value = var.enable_lb ? aws_lb.this[0].arn : ""
}

output "lb_security_group_id" {
  value = var.enable_lb ? aws_security_group.lb[0].id : ""
}
