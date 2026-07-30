variable "vsphere_user" {
  description = "The vSphere user to connect to the vSphere API"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "The vSphere password to connect to the vSphere API"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "The vSphere server to connect to the vSphere API"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter_name" {
  description = "Name of the vSphere datacenter"
  type        = string
  sensitive   = true
}

variable "vsphere_host_name" {
  description = "Name of the vSphere host"
  type        = string
  sensitive   = true
}

variable "vsphere_datastore_name" {
  description = "Name of the vSphere datastore"
  type        = string
  sensitive   = true
}

variable "vsphere_network" {
  description = "Name of the vSphere network"
  type        = string
  sensitive   = true
}

variable "public_key_location" {
  description = "Location of the ssh key in the terraform host"
  type        = string
  sensitive   = true
}

variable "ubuntu_pwd" {
  type        = string
  sensitive   = true
  description = "User ubuntu password"
}

variable "gateway" {
  description = "The gateway for the subnet where VMs will be provisioned"
  type        = string
  sensitive   = true
}

variable "ip_addresses" {
  description = "List of IP addresses to assign to the VMs"
  type        = list(string)
}

variable "n_masters" {
  description = "Number of master nodes"
  type        = number
}

variable "masters_addresses" {
  description = "Master nodes ip addresses"
  type        = list(string)
}

variable "n_workers" {
  description = "Number of worker nodes"
  type        = number
}

variable "workers_addresses" {
  description = "Worker nodes IP addresses"
  type        = list(string)
}