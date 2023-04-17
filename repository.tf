locals {
  // If someone specifies `var.service_image`, the ecr repository will not be created
  // The following variable sets up the effective docker image
  service_image = try(aws_ecr_repository.this[0].repository_url, var.image)
}

// This is a bit odd - we're creating a repository for every environment
// We need to find a better way to do this
resource "aws_ecr_repository" "this" {
  name                 = local.resource_name
  tags                 = local.tags
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.this.arn
  }

  count = var.image == "" ? 1 : 0
}
