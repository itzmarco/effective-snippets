output "masters_addresses" {
  value = phpipam_address.masters_addresses.*.ip_address
}

output "workers_addresses" {
  value = phpipam_address.workers_addresses.*.ip_address
}


output "metallb_reserved_addresses" {
  value = phpipam_address.metallb_addresses.*.ip_address
}

output "vip_address" {
  value = phpipam_address.kubevip_address.*.ip_address
}