locals {
  deployer = {
    role_arn         = try(aws_iam_role.deployer[0].arn, null)
    session_duration = 3600 // 1 hour
    name             = try(aws_iam_user.deployer[0].name, null)
    access_key       = try(aws_iam_access_key.deployer[0].id, null)
    secret_key       = try(aws_iam_access_key.deployer[0].secret, null)
  }
}

// ECS requires the user/role that initiates a deployment
//   to have iam:PassRole access to the execution role
// This grants the deployer user access to this service's execution role
// This is necessary for us to execute `nullstone deploy` on the CLI
resource "aws_iam_user" "deployer" {
  #bridgecrew:skip=CKV_AWS_273: Skipping "Ensure access is controlled through SSO and not AWS IAM defined users". SSO is unavailable to configure.
  name = "deployer-${local.resource_name}"
  tags = local.tags

  count = !local.use_roles ? 1 : 0
}

resource "aws_iam_access_key" "deployer" {
  user = aws_iam_user.deployer[count.index].name

  count = !local.use_roles ? 1 : 0
}

// Add deployer to deployers group defined in the cluster
// This allows the deployer user to perform common operations on the cluster
resource "aws_iam_user_group_membership" "deployers" {
  user   = aws_iam_user.deployer[count.index].name
  groups = [local.deployers_name]

  count = !local.use_roles ? 1 : 0
}

resource "aws_iam_user_policy" "deployer" {
  #bridgecrew:skip=CKV_AWS_40: Skipping `IAM policies attached only to groups or roles reduces management complexity`; Adding a role or group would increase complexity
  user   = aws_iam_user.deployer[count.index].name
  policy = data.aws_iam_policy_document.deployer.json

  count = !local.use_roles ? 1 : 0
}

resource "aws_iam_role" "deployer" {
  name               = "deployer-${local.resource_name}"
  tags               = local.tags
  assume_role_policy = data.aws_iam_policy_document.deployer_assume.json

  count = local.use_roles ? 1 : 0
}

data "aws_iam_policy_document" "deployer_assume" {
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

// Grant deployer a standard policy that was created for the ECS cluster
resource "aws_iam_role_policy_attachment" "deployer_deployers" {
  role       = aws_iam_role.deployer[count.index].name
  policy_arn = local.deployers_policy_arn

  count = local.use_roles ? 1 : 0
}

resource "aws_iam_role_policy" "deployer" {
  role   = aws_iam_role.deployer[count.index].name
  policy = data.aws_iam_policy_document.deployer.json

  count = local.use_roles ? 1 : 0
}

data "aws_iam_policy_document" "deployer" {
  statement {
    sid     = "AllowPassRoleToServiceRoles"
    effect  = "Allow"
    actions = ["iam:PassRole"]

    resources = [
      aws_iam_role.execution.arn,
      aws_iam_role.task.arn,
    ]
  }
}
