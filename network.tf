locals {
  network_block = data.terraform_remote_state.cluster.outputs.network_block
}

data "terraform_remote_state" "network" {
  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${local.network_block}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}