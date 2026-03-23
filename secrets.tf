resource "aws_secretsmanager_secret" "app_secret" {
  for_each = local.managed_secret_keys

  name_prefix             = "${local.block_name}/${each.value}/"
  tags                    = local.tags
  kms_key_id              = aws_kms_alias.this.arn
  recovery_window_in_days = 0 // force delete so that re-adding the secret doesn't cause issues

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.managed_secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.managed_secret_values[each.value]

  lifecycle {
    create_before_destroy = true
  }
}
