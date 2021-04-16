output "cluster_arn" {
  value       = data.aws_ecs_cluster.cluster.arn
  description = "string ||| "
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| "
}

output "image_repo_name" {
  value       = try(aws_ecr_repository.this[0].name, "")
  description = "string ||| "
}

output "image_repo_url" {
  value       = try(aws_ecr_repository.this[0].repository_url, "")
  description = "string ||| "
}

output "image_pusher" {
  value = {
    name       = aws_iam_user.image_pusher.name
    access_key = aws_iam_access_key.image_pusher.id
    secret_key = aws_iam_access_key.image_pusher.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to push images."

  sensitive = true
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
