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

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "tags" {
  description = "List of tags"
  type        = map(string)
}
