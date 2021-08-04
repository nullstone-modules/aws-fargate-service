// ECS requires the user/role that initiates a deployment
//   to have iam:PassRole access to the execution role
// This grants the deployer user (created in the cluster module) access to this service's execution role
// This is necessary for us to execute `nullstone deploy` on the CLI

resource "aws_iam_user_policy_attachment" "deployer-execution" {
  user       = local.deployer_name
  policy_arn = aws_iam_policy.execution-pass-role.arn
}

resource "aws_iam_policy" "execution-pass-role" {
  name_prefix = "${local.resource_name}-pass-role"
  policy      = data.aws_iam_policy_document.deployer-execution.json
}

data "aws_iam_policy_document" "deployer-execution" {
  statement {
    sid       = "AllowPassRoleToExecutionRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.execution.arn]
  }
}
