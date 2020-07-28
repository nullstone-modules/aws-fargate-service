// This is a bit odd - we're creating a repository for every environment
// We need to find a better way to do this
resource "aws_ecr_repository" "this" {
  name = "${var.stack_name}/${var.block_name}-${var.env}"
}
