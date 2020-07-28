data "terraform_remote_state" "network" {
  backend = "pg"

  workspace = "${var.stack_name}-${local.network_block}-${var.env}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}