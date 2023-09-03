data "aws_iam_policy_document" "node_role_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${aws_s3_bucket.node_role_access.arn}/*"]
  }
	statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = ["${aws_s3_bucket.node_role_access.arn}"]
	}
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "node_role_access" {
  name   = "node_role_access"
  policy = data.aws_iam_policy_document.node_role_access.json
}

data "aws_iam_policy_document" "irsa_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${aws_s3_bucket.irsa_access.arn}/*"]
  }
	statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = ["${aws_s3_bucket.irsa_access.arn}"]
	}
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "irsa_access" {
  name   = "irsa_access"
  policy = data.aws_iam_policy_document.irsa_access.json
}
