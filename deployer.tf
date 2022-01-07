// ECS requires the user/role that initiates a deployment
//   to have iam:PassRole access to the execution role
// This grants the deployer user access to this service's execution role
// This is necessary for us to execute `nullstone deploy` on the CLI

resource "aws_iam_user" "deployer" {
  name = "deployer-${local.resource_name}"
  tags = local.tags
}

resource "aws_iam_access_key" "deployer" {
  user = aws_iam_user.deployer.name
}

// Add deployer to deployers group defined in the cluster
// This allows the deployer user to perform common operations on the cluster
resource "aws_iam_user_group_membership" "deployers" {
  user   = aws_iam_user.deployer.name
  groups = [local.deployers_name]
}

resource "aws_iam_user_policy" "deployer" {
  user   = aws_iam_user.deployer.name
  policy = data.aws_iam_policy_document.deployer.json
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
