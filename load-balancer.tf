resource "aws_lb" "this" {
  name               = "${var.stack_name}-${var.env}-${var.block_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids
  security_groups    = [aws_security_group.lb[count.index].id]
  enable_http2       = true
  ip_address_type    = "ipv4"

  access_logs {
    bucket  = module.lb_logs_bucket.bucket_id
    enabled = true
  }

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }

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
  certificate_arn   = data.terraform_remote_state.subdomain[0].outputs.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "lb" {
  name   = "${var.stack_name}/${var.env}/${var.block_name}/lb"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }

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

resource "aws_security_group_rule" "lb-http-from-world" {
  security_group_id = aws_security_group.lb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80

  count = var.enable_lb && ! var.enable_https ? 1 : 0
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
