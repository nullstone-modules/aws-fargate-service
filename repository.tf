locals {
  // If someone specifies `var.service_image`, the ecr repository will not be created
  // The following variable sets up the effective docker image
  service_image = try(aws_ecr_repository.this[0].repository_url, var.service_image)
}

// This is a bit odd - we're creating a repository for every environment
// We need to find a better way to do this
resource "aws_ecr_repository" "this" {
  name = local.resource_name
  tags = data.ns_workspace.this.tags

  count = var.service_image == "" ? 1 : 0
}
