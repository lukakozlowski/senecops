variable "rg_name" {
  description = "Resource group name for resources"
  type        = string
}

variable "location" {
  description = "Geographical location of resources"
  type        = string
}

variable "name" {
  description = "Common part of resource name"
  type        = string
}

variable "tags" {
  description = "List of tags"
  type        = map(string)
}

variable "aks_sku_tier" {
  description = "SKU tier for AKS, possible options: Free, Standard and Premium. (which includes the Uptime SLA)"
  type        = string
  default     = "Free"
}

variable "aks_version" {
  description = "AKS version"
  type        = string
}

variable "aks_node_vm_size" {
  description = "VM size for AKS node pool"
  type        = string
}
