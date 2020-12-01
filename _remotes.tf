data "terraform_remote_state" "base" {
  backend   = "s3"
  workspace = "base"

  config = {
    bucket         = "rimu-tf-state"
    key            = "ritdu-ecom-eu1-tf-base/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "rimu"
    encrypt        = true
    kms_key_id     = "alias/base/s3"
    dynamodb_table = "rimu-tf-state"
  }
}

data "terraform_remote_state" "core_base" {
  backend   = "s3"
  workspace = "base"

  config = {
    bucket         = "rimu-tf-state"
    key            = "rimu-tf-base/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "rimu"
    encrypt        = true
    kms_key_id     = "alias/base/s3"
    dynamodb_table = "rimu-tf-state"
  }
}

data "terraform_remote_state" "core_env" {
  backend   = "s3"
  workspace = "base"

  config = {
    bucket         = "rimu-tf-state"
    key            = "rimu-tf-env/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "rimu"
    encrypt        = true
    kms_key_id     = "alias/base/s3"
    dynamodb_table = "rimu-tf-state"
  }
}


data "terraform_remote_state" "env" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "rimu-tf-state"
    key            = "ritdu-ecom-eu1-tf-env/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "rimu"
    encrypt        = true
    kms_key_id     = "alias/base/s3"
    dynamodb_table = "rimu-tf-state"
  }
}