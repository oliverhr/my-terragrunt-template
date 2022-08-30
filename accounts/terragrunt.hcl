# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load global-level variables
  _glb = read_terragrunt_config("${get_parent_terragrunt_dir()}/globals.hcl").locals

  # Automatically load account-level variables
  _act = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals

  # Automatically load region-level variables
  _reg = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals

  # Automatically load environment-level variables
  _env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  # Extract the variables we need for easy access
  company     = local._glb.company.name.short
  project     = local._glb.project.name.short
  environment = local._env.name.short
  region      = local._reg.name.short

  aws_region     = local._reg.name.full
  aws_account_id = local._act.aws.id

  state_lock_prefix = "${local.company}-${local.project}-${local.account_id}-${local.region}-${local.environment}"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.aws_region}"

      # Only these AWS Account IDs may be operated on by this template
      allowed_account_ids = ["${local.account_id}"]
    }
  EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.state_lock_prefix}-terragrunt-terraform-state-files"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.state_lock_prefix}-terragrunt-terraform-locks-db"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit.
# This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.

# inputs = {
#   namespace   = local.company,
#   tenant      = local.project,
#   environment = local.region,
#   stage       = local.environment,
#
#   tags = {
#     namespace   = local.company,
#     tenant      = local.project,
#     stage       = local.environment,
#     environment = local.region,
#   }
# }
