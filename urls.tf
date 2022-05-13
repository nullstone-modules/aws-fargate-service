locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string)
  additional_private_urls = var.service_port == 0 ? [] : [
    "http://${aws_service_discovery_service.this[0].name}.${local.service_domain}:${var.service_port}"
  ]
  additional_public_urls = []

  private_urls = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
  public_urls  = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
}
