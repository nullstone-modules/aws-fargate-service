output "region" {
  value = data.aws_region.this.name
}

output "cluster_arn" {
  value       = data.aws_ecs_cluster.cluster.arn
  description = "string ||| "
}

output "log_provider" {
  value       = "cloudwatch"
  description = "string ||| "
}

output "log_group_name" {
  value       = module.logs.name
  description = "string ||| "
}

output "log_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
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
    name       = try(aws_iam_user.image_pusher[0].name, "")
    access_key = try(aws_iam_access_key.image_pusher[0].id, "")
    secret_key = try(aws_iam_access_key.image_pusher[0].secret, "")
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to push images."

  sensitive = true
}

output "service_image" {
  value       = "${local.service_image}:${local.app_version}"
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

output "main_container_name" {
  value       = local.container_definition.name
  description = "string ||| The name of the container definition for the main service container"
}

output "service_security_group_id" {
  value       = aws_security_group.this.id
  description = "string ||| "
}

locals {
  additional_private_urls = [
    "http://${aws_service_discovery_service.this.name}.${local.service_domain}:${var.service_port}"
  ]
  additional_public_urls = []
}

output "private_urls" {
  value = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
}

output "public_urls" {
  value = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
}
