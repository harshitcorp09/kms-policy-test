resource "aws_kms_key" "avm_ebs_kms_key" {
  description             = "The default EBS CMK"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.ebs_kms_policy_combined.json
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
  tags                    = merge(var.shared_tags, { "Name" = "DEFAULT-CMK-EBS" })
}

data "aws_iam_policy_document" "ebs_kms_policy_combined" {
  version = "2012-10-17"
  source_policy_documents = concat(var.additional_ebs_kms_policies, [
    data.aws_iam_policy_document.generic_kms_policy_block.json,
    data.aws_iam_policy_document.ebs_kms_policy_block.json
  ])
}

data "aws_iam_policy_document" "generic_kms_policy_block" {
  version   = "2012-10-17"
  policy_id = "key-default-1"
  statement {
    sid       = "This safeguard Allows the AWS account (root) full access to the key"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${var.new_account_number}:root"]
      type        = "AWS"
    }
  }
}

data "aws_iam_policy_document" "ebs_kms_policy_block" {
  version = "2012-10-17"
  statement {
    sid       = "Allow use of the key for all principals in the account that are authorized to use EBS"
    effect    = "Allow"
    actions   = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:List*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext"
    ]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [var.new_account_number]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.${var.region}.amazonaws.com"]
    }
  }
}
