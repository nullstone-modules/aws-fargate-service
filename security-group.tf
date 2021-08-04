resource "aws_security_group" "this" {
  name   = local.resource_name
  vpc_id = data.ns_connection.network.outputs.vpc_id
  tags   = merge(data.ns_workspace.this.tags, { Name = local.resource_name })
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
  from_port         = var.service_port
  to_port           = var.service_port
  cidr_blocks       = data.ns_connection.network.outputs.private_cidrs
}

// TODO: Drop this once we have a better way of reaching via bastion
resource "aws_security_group_rule" "this-http-from-public-subnets" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.service_port
  to_port           = var.service_port
  cidr_blocks       = data.ns_connection.network.outputs.public_cidrs
}

resource "aws_security_group_rule" "this-http-to-private-subnets" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = data.ns_connection.network.outputs.private_cidrs
}
