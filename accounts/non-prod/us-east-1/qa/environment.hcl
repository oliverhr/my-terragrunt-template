# Set common variables for the environment.
locals {
  info = {
    full_name  = "quality-assurance"
    short_name = "qa"
  }
  name = local.info.short_name
}
