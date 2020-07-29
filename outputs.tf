output "log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "repo_name" {
  value = aws_ecr_repository.this.name
}

output "service_name" {
  value = aws_ecs_service.this.name
}

output "task_family" {
  value = aws_ecs_task_definition.this.family
}

output "cluster_block" {
  value = var.parent_blocks.cluster
}

output "network_block" {
  value = local.network_block
}
