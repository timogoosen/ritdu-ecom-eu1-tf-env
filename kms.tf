#
# KMS keys
# See: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
#
# The only reason this is done here and not in tf-env, is that tf-env is all
# within the same account and we are sharing keys for now out of simplicity
# reasons. Good practice to change this and test out key-rolling :troll:
#

#########
# Generic
#########
data "aws_iam_policy_document" "kms_policy" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_kms_key" "s3" {
  description = "${terraform.workspace} KMS key for S3"
  policy      = data.aws_iam_policy_document.kms_policy.json
}

resource "aws_kms_key" "db" {
  description = "${terraform.workspace} KMS key for Databases"
  policy      = data.aws_iam_policy_document.kms_policy.json
}

resource "aws_kms_key" "params" {
  description = "${terraform.workspace} KMS key for Parameters"
  policy      = data.aws_iam_policy_document.kms_policy.json
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${terraform.workspace}/s3"
  target_key_id = aws_kms_key.s3.key_id
}

resource "aws_kms_alias" "db" {
  name          = "alias/${terraform.workspace}/db"
  target_key_id = aws_kms_key.db.key_id
}

resource "aws_kms_alias" "params" {
  name          = "alias/${terraform.workspace}/params"
  target_key_id = aws_kms_key.params.key_id
}

output "kms_s3_arn" {
  value = aws_kms_key.s3.arn
}

output "kms_db_arn" {
  value = aws_kms_key.db.arn
}

output "kms_params_arn" {
  value = aws_kms_key.params.arn
}

############
# Cloudwatch
############
data "aws_iam_policy_document" "kms_policy_cloudwatch" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "cloudwatch" {
  description = "${terraform.workspace} KMS key for Cloudwatch"
  policy      = data.aws_iam_policy_document.kms_policy_cloudwatch.json
}

resource "aws_kms_alias" "cloudwatch" {
  name          = "alias/${terraform.workspace}/cloudwatch"
  target_key_id = aws_kms_key.cloudwatch.key_id
}

output "kms_cloudwatch_arn" {
  value = aws_kms_key.cloudwatch.arn
}

###########################################################
# AMI
# https://forums.aws.amazon.com/thread.jspa?threadID=277523
###########################################################
data "aws_iam_policy_document" "kms_policy_ami" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.base.outputs.service_linked_role_spot_arn]
    }
  }

  statement {
    actions = ["kms:CreateGrant"]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.base.outputs.service_linked_role_spot_arn]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = ["true"]
    }
  }
}

resource "aws_kms_key" "ami" {
  description = "${terraform.workspace} KMS key for AMIs"
  policy      = data.aws_iam_policy_document.kms_policy_ami.json
}

resource "aws_kms_alias" "ami" {
  name          = "alias/${terraform.workspace}/ami"
  target_key_id = aws_kms_key.ami.key_id
}

output "kms_ami_arn" {
  value = aws_kms_key.ami.arn
}

#####
# SQS
#####
data "aws_iam_policy_document" "kms_policy_sqs" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt",
    ]

    resources = ["*"]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com",
        "s3.amazonaws.com",
        "sns.amazonaws.com",
      ]
    }
  }
}

resource "aws_kms_key" "sqs" {
  description = "${terraform.workspace} KMS key for SQS"
  policy      = data.aws_iam_policy_document.kms_policy_sqs.json
}

resource "aws_kms_alias" "sqs" {
  name          = "alias/${terraform.workspace}/sqs"
  target_key_id = aws_kms_key.sqs.key_id
}

output "kms_sqs_arn" {
  value = aws_kms_key.sqs.arn
}