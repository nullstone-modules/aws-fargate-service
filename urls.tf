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

locals {
  uri_matcher = "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?"
}

locals {
  authority_matcher = "^(?:(?P<user>[^@]*)@)?(?:(?P<host>[^:]*))(?:[:](?P<port>[\\d]*))?"
  // These tests are here to verify the authority_matcher regex above
  // To verify, uncomment the following lines and issue `echo 'local.tests' | terraform console`
  /*
  test1 = regex(local.authority_matcher, "nullstone.io")
  test2 = regex(local.authority_matcher, "brad@nullstone.io")
  test3 = regex(local.authority_matcher, "brad:password@nullstone.io")
  test4 = regex(local.authority_matcher, "nullstone.io:9000")
  test5 = regex(local.authority_matcher, "brad@nullstone.io:9000")
  test6 = regex(local.authority_matcher, "brad:password@nullstone.io:9000")

  tests = tomap({
    "nullstone.io": local.test1,
    "brad@nullstone.io": local.test2,
    "brad:password@nullstone.io": local.test3,
    "nullstone.io:9000": local.test4,
    "brad@nullstone.io:9000": local.test5,
    "brad:password@nullstone.io:9000": local.test6,
  })
  */
}

locals {
  private_hosts = [for url in local.private_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
  public_hosts  = [for url in local.public_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
}
