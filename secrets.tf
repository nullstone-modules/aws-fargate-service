locals {
  // We use `local.secret_keys` to create secret resources
  // If we used `length(local.capabilities.secrets)`,
  //   terraform would complain about not knowing count of the resource until after apply
  // This is because the name of secrets isn't computed in the modules; only the secret value
  raw_secret_keys = [for secret in lookup(local.capabilities, "secrets", []) : secret["name"]]
  secret_keys     = can(nonsensitive(local.raw_secret_keys)) ? toset(nonsensitive(local.raw_secret_keys)) : toset(local.raw_secret_keys)
  cap_secrets     = { for secret in try(local.capabilities.secrets, []) : secret["name"] => secret["value"] }

  // app_secrets is prepared in the form [{ name = "", valueFrom = "<arn>" }, ...] for injection into ECS services
  app_secrets = [for key in local.secret_keys : { name = key, valueFrom = aws_secretsmanager_secret.app_secret[key].arn }]
}

resource "aws_secretsmanager_secret" "app_secret" {
  for_each = local.secret_keys

  name_prefix = "${local.block_name}/${each.value}/"
  tags        = local.tags
  kms_key_id  = aws_kms_alias.this.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.cap_secrets[each.value]

  lifecycle {
    create_before_destroy = true
  }
}
