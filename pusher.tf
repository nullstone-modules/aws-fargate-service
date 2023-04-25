resource "aws_iam_user" "image_pusher" {
  name = "image-pusher-${local.resource_name}"
  tags = local.tags

  count = var.image == "" ? 1 : 0
}

resource "aws_iam_access_key" "image_pusher" {
  user = aws_iam_user.image_pusher[count.index].name

  count = var.image == "" ? 1 : 0
}

resource "aws_iam_user_policy" "image_pusher" {
  #bridgecrew:skip=CKV_AWS_40: Skipping `IAM policies attached only to groups or roles reduces management complexity`; Adding a role or group would increase complexity
  name   = "AllowECRPush"
  user   = aws_iam_user.image_pusher[count.index].name
  policy = data.aws_iam_policy_document.image_pusher.json

  count = var.image == "" ? 1 : 0
}

data "aws_iam_policy_document" "image_pusher" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    // The actions listed are necessary to perform actions to push ECR images
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

  statement {
    sid       = "AllowAuthorization"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}
