locals {
  // Region-specific envoy images
  // See https://docs.aws.amazon.com/app-mesh/latest/userguide/envoy.html
  envoy_images = tomap({
    "me-south-1" = "772975370895.dkr.ecr.me-south-1.amazonaws.com/aws-appmesh-envoy:v1.17.2.0-prod"
    "ap-east-1"  = "856666278305.dkr.ecr.ap-east-1.amazonaws.com/aws-appmesh-envoy:v1.17.2.0-prod"
    "eu-south-1" = "422531588944.dkr.ecr.eu-south-1.amazonaws.com/aws-appmesh-envoy:v1.17.2.0-prod"
    "af-south-1" = "924023996002.dkr.ecr.af-south-1.amazonaws.com/aws-appmesh-envoy:v1.17.2.0-prod"
  })
  regional_envoy_image = "840364872350.dkr.ecr.${data.aws_region.this.name}.amazonaws.com/aws-appmesh-envoy:v1.17.2.0-prod"
  envoy_image          = lookup(local.envoy_images, data.aws_region.this.name, local.regional_envoy_image)
}
