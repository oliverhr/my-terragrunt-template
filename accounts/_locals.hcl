locals {
  levels = regex(
    "(?P<root>.*?)/(?P<account>.*?)/(?P<region>.*?)/(?P<env>.*?)/(?P<module>.*)",
    trimprefix(abspath(get_original_terragrunt_dir()), abspath(get_parent_terragrunt_dir()))
  )

  account_level_path = "${get_parent_terragrunt_dir()}/${local.levels.account}"
  region_level_path  = "${local.account_level_path}/${local.levels.region}"
  env_level_path     = "${local.region_level_path}/${local.levels.env}"

  _glb = read_terragrunt_config("${get_parent_terragrunt_dir()}/globals.hcl").locals
  _act = read_terragrunt_config("${local.account_level_path}/account.hcl").locals
  _reg = read_terragrunt_config("${local.region_level_path}/region.hcl").locals
  _env = read_terragrunt_config("${local.env_level_path}/environment.hcl").locals

  # Extract the variables we need for easy access
  company     = local._glb.company.name.short
  project     = local._glb.project.name.short
  environment = local._env.name.short

  aws_region     = local._reg.name.short
  aws_account_id = local._act.aws.id
}
