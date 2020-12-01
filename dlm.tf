data "aws_iam_policy_document" "dlm_backup_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "dlm_backup_policy" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  statement {
    actions = ["ec2:CreateTags"]

    resources = ["arn:aws:ec2:*::snapshot/*"]
  }
}

resource "aws_iam_role" "dlm_backup" {
  name = "${terraform.workspace}-dlm-backup-role"

  assume_role_policy = data.aws_iam_policy_document.dlm_backup_assume.json
}

resource "aws_iam_role_policy" "dlm_backup" {
  name   = "${terraform.workspace}-dlm-backup-policy"
  role   = aws_iam_role.dlm_backup.id
  policy = data.aws_iam_policy_document.dlm_backup_policy.json
}

resource "aws_dlm_lifecycle_policy" "backup" {
  description        = "${terraform.workspace} Backup DLM lifecycle policy"
  execution_role_arn = aws_iam_role.dlm_backup.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "30 days of daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["01:00"]
      }

      retain_rule {
        count = 30
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = true
    }

    target_tags = {
      "${terraform.workspace}_backup" = "true"
    }
  }
}