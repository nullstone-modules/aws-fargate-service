module "load_balancer" {
  source = "nullstone-modules/load-balancer-fargate/aws"

  name               = local.resource_name
  tags               = data.ns_workspace.this.tags
  enable_access_logs = true

  https = {
    enabled         = var.enable_https && local.cert_arn != ""
    certificate_arn = local.cert_arn
  }
  network = {
    vpc_id     = data.ns_connection.network.outputs.vpc_id
    subnet_ids = data.ns_connection.network.outputs.public_subnet_ids
  }
  service = {
    port              = var.service_port
    security_group_id = aws_security_group.this.id
  }

  count = var.enable_lb ? 1 : 0
}
