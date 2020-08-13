data "terraform_remote_state" "cluster" {
  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.cluster}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = data.terraform_remote_state.cluster.outputs["cluster_name"]
}

data "aws_iam_role" "execution" {
  name = data.terraform_remote_state.cluster.outputs["cluster_execution_role_name"]
}
