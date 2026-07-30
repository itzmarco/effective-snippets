terraform {
  source = "../shared"
}


dependency "ips" {
  config_path = "../ips"
  mock_outputs = {
    selected_addresses = [
      for el in range(local.shared_variables.locals.n_masters) : "10.10.10.${el + 10}"
    ]
  }
}

locals {
  shared_variables = read_terragrunt_config(find_in_parent_folders("shared/variables.hcl"))
}

inputs = {
  n_masters         = local.shared_variables.locals.n_masters
  n_workers         = local.shared_variables.locals.n_workers
  masters_addresses = dependency.ips.outputs.masters_addresses
  workers_addresses = dependency.ips.outputs.workers_addresses
}