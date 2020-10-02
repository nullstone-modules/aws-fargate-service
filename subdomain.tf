data "terraform_remote_state" "subdomain" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.subdomain}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

locals {
  cert_arn          = var.enable_lb && var.enable_https ? data.terraform_remote_state.subdomain[0].outputs.cert_arn : ""
  subdomain_name    = var.enable_lb && var.enable_https ? data.terraform_remote_state.subdomain[0].outputs.subdomain.name : ""
  subdomain_zone_id = var.enable_lb && var.enable_https ? data.terraform_remote_state.subdomain[0].outputs.subdomain.zone_id : ""
}