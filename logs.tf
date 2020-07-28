resource "aws_cloudwatch_log_group" "this" {
  name = "/${var.block_name}/${var.env}"

  tags = {
    Stack       = var.stack_name
    Block       = var.block_name
    Environment = var.env
  }
}
