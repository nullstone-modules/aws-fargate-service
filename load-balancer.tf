resource "aws_lb" "this" {
  name               = local.resource_name
  internal           = false
  load_balancer_type = "application"
  subnets            = data.ns_connection.network.outputs.public_subnet_ids
  security_groups    = [aws_security_group.lb[count.index].id]
  enable_http2       = true
  ip_address_type    = "ipv4"

  access_logs {
    bucket  = module.lb_logs_bucket[count.index].bucket_id
    enabled = true
  }

  tags = data.ns_workspace.this.tags

  count = var.enable_lb ? 1 : 0
}

resource "aws_lb_listener" "http" {
  count = var.enable_lb && ! var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this[count.index].arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http-redirect-to-https" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this[count.index].arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = local.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "lb" {
  name   = "${local.resource_name}/lb"
  vpc_id = data.ns_connection.network.outputs.vpc_id
  tags   = merge(data.ns_workspace.this.tags, { Name = "${data.ns_workspace.this.slashed_name}/lb" })

  count = var.enable_lb ? 1 : 0
}

resource "aws_security_group_rule" "lb-https-from-world" {
  security_group_id = aws_security_group.lb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443

  count = var.enable_lb && var.enable_https ? 1 : 0
}

// This rule is always enabled; when we are listening on https, we still want to force http to https through redirect
resource "aws_security_group_rule" "lb-http-from-world" {
  security_group_id = aws_security_group.lb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80

  count = var.enable_lb ? 1 : 0
}

resource "aws_security_group_rule" "lb-http-to-service" {
  security_group_id        = aws_security_group.lb[count.index].id
  source_security_group_id = aws_security_group.this.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80

  count = var.enable_lb ? 1 : 0
}

resource "aws_security_group_rule" "service-http-from-lb" {
  security_group_id        = aws_security_group.this.id
  source_security_group_id = aws_security_group.lb[count.index].id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80

  count = var.enable_lb ? 1 : 0
}
