variable "phpipam_app_id" {
  description = "The App ID to connect to the IPAM API"
  type        = string
  sensitive   = true
}

variable "phpipam_user" {
  description = "The IPAM user to connect to the IPAM API"
  type        = string
  sensitive   = true
}

variable "phpipam_password" {
  description = "The IPAM password to connect to the IPAM API"
  type        = string
  sensitive   = true
}

variable "phpipam_address" {
  description = "The IPAM address to connect to the IPAM API"
  type        = string
  sensitive   = true
}

variable "phpipam_subnet" {
  description = "The subnet where VMs will be provisioned"
  type        = string
  sensitive   = true
}

variable "n_workers" {
  description = "Total number of k8s workers that need an IP"
  type        = number
}

variable "n_masters" {
  description = "Total number of k8s control planes that need an IP"
  type        = number
}

variable "n_metallb_addresses" {
  description = "Number of metallb addresses that need to be provisioned"
  type        = number
}

variable "has_vip" {
  description = "Whether a VIP is needed for the cluster"
  type        = bool
}