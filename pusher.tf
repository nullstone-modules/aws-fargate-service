resource "aws_iam_user" "image_pusher" {
  name = "image-pusher-${random_string.resource_suffix.result}"
  tags = data.ns_workspace.this.tags

  count = var.service_image == "" ? 1 : 0
}

resource "aws_iam_access_key" "image_pusher" {
  user = aws_iam_user.image_pusher[count.index].name

  count = var.service_image == "" ? 1 : 0
}

// The actions listed are necessary to perform actions to push ECR images
resource "aws_iam_user_policy" "image_pusher" {
  name   = "AllowECRPush"
  user   = aws_iam_user.image_pusher[count.index].name
  policy = data.aws_iam_policy_document.image_pusher.json

  count = var.service_image == "" ? 1 : 0
}

data "aws_iam_policy_document" "image_pusher" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]

    resources = aws_ecr_repository.this.*.arn
  }
}
