locals {
  subdomain_enabled = var.parent_blocks.subdomain != "" && var.enable_lb
}

data "terraform_remote_state" "subdomain" {
  count = local.subdomain_enabled ? 1 : 0

  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.subdomain}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

locals {
  cert_arn          = local.subdomain_enabled ? data.terraform_remote_state.subdomain[0].outputs.cert_arn : ""
  subdomain_name    = local.subdomain_enabled ? data.terraform_remote_state.subdomain[0].outputs.subdomain.name : ""
  subdomain_zone_id = local.subdomain_enabled ? data.terraform_remote_state.subdomain[0].outputs.subdomain.zone_id : ""
}