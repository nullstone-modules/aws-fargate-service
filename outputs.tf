output "region" {
  value       = data.aws_region.this.name
  description = "string ||| The region where the ECS container resides."
}

output "cluster_arn" {
  value       = data.aws_ecs_cluster.cluster.arn
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

output "deployer" {
  value = {
    name       = aws_iam_user.deployer.name
    access_key = aws_iam_access_key.deployer.id
    secret_key = aws_iam_access_key.deployer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to deploy ECS services."

  sensitive = true
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
