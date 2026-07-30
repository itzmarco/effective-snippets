resource "vsphere_tag_category" "category" {
  name        = "k8s-zone"
  description = "This tags enable automatic volume provisioning for the k8s cluster - Managed by Terraform"
  cardinality = "SINGLE"

  associable_types = [
    "Datastore",
    "StoragePod"
  ]
}