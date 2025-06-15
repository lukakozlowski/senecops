variable "cert_manager_ver" {
  description = "Helm chart version"
  type        = string
}

variable "ingress_nginx_ver" {
  description = "Helm chart version"
  type        = string
}

variable "external_dns_ver" {
  description = "Helm chart version"
  type        = string
}

variable "domain_name" {
  description = "Domain name like: example.com"
  type = string
}

variable "aws_access_key_id" {
  description = "AWS - Auth value Access Key ID"
  type = string
  sensitive = true
}

variable "aws_access_key_secret" {
  description = "AWS - Auth value Access Key Secret"
  type = string
  sensitive = true
}

variable "ingress_ip_address" {}
variable "ingress_domain_name_label" {}
