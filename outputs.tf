output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| "
}

output "repo_name" {
  value       = try(aws_ecr_repository.this[0].name, "")
  description = "string ||| "
}

output "repo_url" {
  value       = try(aws_ecr_repository.this[0].repository_url, "")
  description = "string ||| "
}

output "service_image" {
  value       = "${local.service_image}:${var.service_image_tag}"
  description = "string ||| "
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "string ||| "
}

output "service_id" {
  value       = aws_ecs_service.this.id
  description = "string ||| "
}

output "task_family" {
  value       = aws_ecs_task_definition.this.family
  description = "string ||| "
}

output "service_security_group_id" {
  value       = aws_security_group.this.id
  description = "string ||| "
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "string ||| "
}

output "lb_arn" {
  value       = join("", aws_lb.this.*.arn)
  description = "string ||| "
}

output "lb_security_group_id" {
  value       = join("", aws_security_group.lb.*.id)
  description = "string ||| "
}
