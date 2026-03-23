output "region" {
  value       = local.region
  description = "string ||| The region where the ECS container resides."
}

output "cluster_arn" {
  value       = local.cluster_arn
  description = "string ||| "
}

output "log_provider" {
  value       = local.log_provider
  description = "string ||| "
}

output "log_group_name" {
  value       = module.logs.name
  description = "string ||| "
}

output "log_reader" {
  value       = merge(module.logs.reader, { session_duration : 3600 })
  description = "object({ role_arn: string, session_duration: number }) ||| An AWS Role with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

output "metrics_provider" {
  value       = "cloudwatch"
  description = "string ||| "
}

output "metrics_reader" {
  value       = merge(module.logs.reader, { session_duration : 3600 })
  description = "object({ role_arn: string, session_duration: number }) ||| An AWS Role with explicit privilege to read metrics from Cloudwatch."
  sensitive   = true
}

output "metrics_mappings" {
  value = local.metrics_mappings
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
  value       = local.pusher
  description = "object({ role_arn: string, session_duration: number }) ||| An AWS role with explicit privilege to push images."
}

output "deployer" {
  value       = local.deployer
  description = "object({ role_arn: string, session_duration: number, name: string, access_key: string, secret_key: string}) ||| An AWS IAM identity with explicit privilege to deploy ECS services."
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "string ||| The name of the ECS service."
}

output "main_container_name" {
  value       = local.container_definition.name
  description = "string ||| The name of the container definition for the main service container"
}

output "task_arn" {
  value       = aws_ecs_task_definition.this.arn
  description = "string ||| The AWS ARN of the app task definition."
}

output "app_security_group_id" {
  value       = aws_security_group.this.id
  description = "string ||| The ID of the security group attached to the app."
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}

output "private_hosts" {
  value       = local.private_hosts
  description = "list(string) ||| A list of Hostnames only accessible inside the network"
}

output "public_hosts" {
  value       = local.public_hosts
  description = "list(string) ||| A list of Hostnames accessible to the public"
}
