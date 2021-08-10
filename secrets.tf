locals {
  // We use `local.secret_keys` to create secret resources
  // If we used `length(local.capabilities.secrets)`,
  //   terraform would complain about not knowing count of the resource until after apply
  // This is because the name of secrets isn't computed in the modules; only the secret value
  secret_keys = toset(nonsensitive([for secret in local.capabilities.secrets : secret["name"]]))
  cap_secrets = { for secret in local.capabilities.secrets : secret["name"] => secret["value"] }
  app_secrets = [for key in local.secret_keys : { name = key, valueFrom = aws_secretsmanager_secret.app_secret[key].arn }]
}

resource "aws_secretsmanager_secret" "app_secret" {
  for_each = local.secret_keys

  name = "${local.resource_name}/${each.value}"
  tags = data.ns_workspace.this.tags
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.cap_secrets[each.value]
}
