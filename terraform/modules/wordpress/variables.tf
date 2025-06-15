variable "wordpress_ver" {
  description = "WordPress Helm chart version"
  type = string
}

variable "domain_name" {
  description = "Domain name for WordPress, like: wp.example.com"
  type = string
}

variable "namespace" {
  description = "Namespace where WordPress should be placed"
  type = string
}

variable "username" {
  description = "Database username"
  type = string
  sensitive = true
}

variable "password" {
  description = "Database password"
  type = string
  sensitive = true
}

variable "db_name" {
  description = "Database name"
  type = string
}

variable "host" {
  description = "Database server host address, like: psql.example.com"
  type = string
}

variable "port" {
  description = "Server port number"
  type = number
}
