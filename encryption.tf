resource "aws_kms_key" "this" {
  description         = "Encryption key for service ${local.resource_name}"
  enable_key_rotation = true
  is_enabled          = true
  tags                = local.tags
  policy              = data.aws_iam_policy_document.encryption_key.json
}

data "aws_iam_policy_document" "encryption_key" {
  statement {
    sid       = "Enable IAM User permissions"
    effect    = "Allow"
    resources = [aws_kms_key.this.arn]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Enable Cloudwatch Log encryption"
    effect    = "Allow"
    resources = [aws_kms_key.this.arn]
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.this.name}.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}
