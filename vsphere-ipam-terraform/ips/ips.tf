data "phpipam_subnet" "subnet" {
  subnet_address = var.phpipam_subnet
  subnet_mask    = 24
}

resource "phpipam_address" "masters_addresses" {
  count       = var.n_masters
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  description = "IP dedicated to a k8s master"
  note        = "Managed by Terraform"
}

resource "phpipam_address" "workers_addresses" {
  count       = var.n_workers
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  description = "IP dedicated to a k8s worker"
  note        = "Managed by Terraform"
}

resource "phpipam_address" "metallb_addresses" {
  count       = var.n_metallb_addresses
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  description = "IP reserved to MetalLB for load balancing"
  note        = "Managed by Terraform"
}

resource "phpipam_address" "kubevip_address" {
  count       = var.has_vip ? 1 : 0
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  description = "IP reserved to KubeVIP"
  note        = "Managed by Terraform"
}