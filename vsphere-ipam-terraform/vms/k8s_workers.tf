locals {
  k8s_worker = {
    n-vcpus    = 12
    memory-mb  = (2048 * 4) * 8 # ~ 64 GB
    storage-gb = 164
  }
}

resource "vsphere_virtual_machine" "k8s_workers" {
  annotation       = "K8s Cluster VM - Worker Node - Managaed by Terraform"
  count            = var.n_workers
  name             = "K8S-WORKER-${count.index + 1}"
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_host.host.resource_pool_id

  enable_logging = true

  num_cpus = local.k8s_worker["n-vcpus"]
  memory   = local.k8s_worker["memory-mb"]

  hardware_version = 19

  wait_for_guest_net_timeout  = 0
  wait_for_guest_ip_timeout   = 0
  wait_for_guest_net_routable = false

  network_interface {
    network_id = data.vsphere_ovf_vm_template.ovfRemote.ovf_network_map["VM Network"]
  }

  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = local.k8s_worker["storage-gb"]
    thin_provisioned = true
    eagerly_scrub    = false
    unit_number      = 0        
    io_share_level   = "normal" 
    io_share_count   = 1000     
  }

  ovf_deploy {
    allow_unverified_ssl_cert = false
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovfRemote.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovfRemote.disk_provisioning
    ip_protocol               = data.vsphere_ovf_vm_template.ovfRemote.ip_protocol
    ip_allocation_policy      = data.vsphere_ovf_vm_template.ovfRemote.ip_allocation_policy
    ovf_network_map           = data.vsphere_ovf_vm_template.ovfRemote.ovf_network_map
  }

  extra_config = {

    "guestinfo.metadata" = base64encode(
      templatefile(
        "${path.cwd}/templates/metadata.tftpl",
        {
          ip_address = var.workers_addresses[count.index]
          gateway    = var.gateway
          hostname   = "worker-${count.index + 1}"
        }
      )
    )
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode(
      templatefile(
        "${path.cwd}/templates/userdata.tftpl",
        {
          user_password_hash = bcrypt(var.ubuntu_pwd)
          ssh_key            = trimspace(data.local_file.ssh_public_key.content)
        }
      )
    )
    "guestinfo.userdata.encoding" = "base64"
    "disk.EnableUUID"             = "TRUE"
  }

  vapp {
    properties = {
      "hostname"    = "worker-${count.index + 1}"
      "instance-id" = "ubuntu-2404-k8s-worker-${count.index + 1}"
    }
  }

  lifecycle {
    ignore_changes = [
      ovf_deploy,
      vapp,
      extra_config["guestinfo.metadata"],
      extra_config["guestinfo.userdata"]
    ]
  }

}