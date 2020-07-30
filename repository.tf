// This is a bit odd - we're creating a repository for every environment
// We need to find a better way to do this
resource "aws_ecr_repository" "this" {
  name = "${var.stack_name}/${var.env}-${var.block_name}"

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}
