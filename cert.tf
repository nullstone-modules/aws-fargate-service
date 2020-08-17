resource "aws_acm_certificate" "this" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  domain_name               = data.terraform_remote_state.subdomain[count.index].outputs.subdomain_name
  validation_method         = "DNS"
  subject_alternative_names = []

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_acm_certificate_validation" "this" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  certificate_arn         = aws_acm_certificate.this[count.index].arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}

resource "aws_route53_record" "cert_validation" {
  count = var.enable_lb && var.enable_https ? 1 : 0

  name            = aws_acm_certificate.this[count.index].domain_validation_options[0]["resource_record_name"]
  type            = "CNAME"
  allow_overwrite = true
  zone_id         = data.terraform_remote_state.subdomain[count.index].outputs.subdomain_zone_id
  records         = [aws_acm_certificate.this[count.index].domain_validation_options[0]["resource_record_value"]]
  ttl             = 60
}
