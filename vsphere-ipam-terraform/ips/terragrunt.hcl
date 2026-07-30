terraform {
  source = "../shared"
}

locals {
  shared_variables = read_terragrunt_config(find_in_parent_folders("shared/variables.hcl"))
}


inputs = {
  n_metallb_addresses = local.shared_variables.locals.n_metallb_addresses
  has_vip             = local.shared_variables.locals.has_vip
  n_masters           = local.shared_variables.locals.n_masters
  n_workers           = local.shared_variables.locals.n_workers
}