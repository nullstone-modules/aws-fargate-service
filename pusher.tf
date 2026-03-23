locals {
  pusher = {
    role_arn         = try(aws_iam_role.pusher[0].arn, "")
    session_duration = 3600 // 1 hour
  }
}

resource "aws_iam_role" "pusher" {
  name               = "pusher-${local.resource_name}"
  tags               = local.tags
  assume_role_policy = data.aws_iam_policy_document.pusher_assume.json

  count = var.image == "" ? 1 : 0
}

data "aws_iam_policy_document" "pusher_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:SetSourceIdentity",
      "sts:TagSession",
    ]

    principals {
      type        = "AWS"
      identifiers = [local.ns_agent_user_arn]
    }
  }
}

resource "aws_iam_role_policy" "pusher" {
  name   = "AllowImagePush"
  role   = aws_iam_role.pusher[count.index].name
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
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:ListImages",
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
