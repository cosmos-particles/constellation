data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = var.assume_role_actions

    principals {
      type        = "Service"
      identifiers = var.trusted_service_principals
    }

    dynamic "condition" {
      for_each = var.source_account_id != null ? [var.source_account_id] : []
      content {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [condition.value]
      }
    }

    dynamic "condition" {
      for_each = length(var.source_arns) > 0 ? [var.source_arns] : []
      content {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = condition.value
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = "${var.cluster_name}-${var.name}"
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary_arn
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = aws_iam_role.this.name
  role = aws_iam_role.this.name
  tags = var.tags
}
