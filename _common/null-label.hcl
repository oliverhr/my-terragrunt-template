terraform {
  source = "git::https://github.com/cloudposse/terraform-null-label.git//.?ref=0.25.0"
}

locals {
 var = read_terragrunt_config(find_in_parent_folders("_locals.hcl")).locals
}


inputs = {
}
