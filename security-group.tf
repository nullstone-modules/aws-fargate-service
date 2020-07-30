resource "aws_security_group" "this" {
  name = "${var.stack_name}-${var.env}-${var.block_name}"

  tags = {

  }
}
