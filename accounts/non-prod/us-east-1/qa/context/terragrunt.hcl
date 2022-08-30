include "root" {
  path = find_in_parent_folders()
}

include "base" {
  path = find_in_parent_folders("_common/null-label.hcl")
}

locals {
  var = read_terragrunt_config(find_in_parent_folders("_locals.hcl")).locals
}

inputs = {
}
