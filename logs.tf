resource "aws_cloudwatch_log_group" "this" {
  name = "/${var.env}/${var.block_name}"

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}
