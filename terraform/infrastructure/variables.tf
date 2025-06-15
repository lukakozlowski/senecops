variable "env_name" {
  description = "Environment name / type, like: dev, stg, prod, etc"
  type        = string
}

variable "location" {
  description = "Geographical location of resources"
  type        = string
}

variable "project_name" {
  description = "Project name / purpose, something that shortly describe destiny, fe. senops (senec ops), supp (support)"
  type        = string
}

variable "domain_name" {
  description = "Domain name, fe. example.com"
  type        = string
}

variable "db_name" {
  description = "Database name for WordPress"
  type        = string
}

variable "az_client_id" {
  description = "Azure - Auth value client_id for service principal"
  type        = string
  sensitive   = true
}

variable "az_client_secret" {
  description = "Azure - Auth value client_secret for service principal"
  type        = string
  sensitive   = true
}

variable "az_tenant_id" {
  description = "Azure - Auth value tenant_id for service principal"
  type        = string
  sensitive   = true
}

variable "az_subscription_id" {
  description = "Azure - Auth value subscription_id for service principal"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWS - Auth value Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_access_key_secret" {
  description = "AWS - Auth value Access Key Secret"
  type        = string
  sensitive   = true
}
