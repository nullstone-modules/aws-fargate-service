resource "aws_security_group" "this" {
  name   = "${var.stack_name}/${var.env}/${var.block_name}"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_security_group_rule" "this-https-to-world" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "this-http-from-private-subnets" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = data.terraform_remote_state.network.outputs.private_cidrs
}

resource "aws_security_group_rule" "this-http-to-private-subnets" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = data.terraform_remote_state.network.outputs.private_cidrs
}
