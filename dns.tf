resource "aws_route53_record" "alias" {
  count = var.enable_lb && local.subdomain_zone_id != "" ? 1 : 0

  zone_id = local.subdomain_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = module.load_balancer[count.index].lb_dns_name
    zone_id                = module.load_balancer[count.index].lb_zone_id
    evaluate_target_health = false
  }
}
