data "terraform_remote_state" "postgres" {
  count = var.parent_blocks.postgres != "" ? 1 : 0

  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.postgres}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

locals {
  db_user_security_group_id = var.parent_blocks.postgres == "" ? "" : data.terraform_remote_state.postgres[0].outputs.db_user_security_group_id
}

resource "aws_security_group_rule" "this-to-postgres" {
  count = var.parent_blocks.postgres != "" ? 1 : 0

  security_group_id        = aws_security_group.this.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = data.terraform_remote_state.postgres[0].outputs.db_security_group_id
}
