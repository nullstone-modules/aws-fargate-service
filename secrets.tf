locals {
  // We use `local.secret_keys` to create secret resources
  // If we used `length(local.capabilities.secrets)`,
  //   terraform would complain about not knowing count of the resource until after apply
  // This is because the name of secrets isn't computed in the modules; only the secret value
  cap_secrets = { for secret in try(local.capabilities.secrets, []) : secret["name"] => secret["value"] }
  all_secrets = merge(local.cap_secrets, var.service_secrets)
  secret_keys = can(nonsensitive(keys(local.all_secrets))) ? toset(nonsensitive(keys(local.all_secrets))) : toset(keys(local.all_secrets))

  // secret_refs is prepared in the form [{ name = "", valueFrom = "<arn>" }, ...] for injection into ECS services
  secret_refs = [for key in local.secret_keys : { name = key, valueFrom = aws_secretsmanager_secret.app_secret[key].arn }]
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
  secret_string = local.all_secrets[each.value]

  lifecycle {
    create_before_destroy = true
  }
}
