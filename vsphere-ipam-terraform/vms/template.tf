data "vsphere_ovf_vm_template" "ovfRemote" {
  name                 = "noble-server-cloudimg-amd64.ova"
  disk_provisioning    = "thin"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_host.host.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  remote_ovf_url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.ova"
  ip_protocol          = "IPV4"
  ip_allocation_policy = "STATIC_MANUAL"

  ovf_network_map = {
    "VM Network" : data.vsphere_network.network.id
  }
}