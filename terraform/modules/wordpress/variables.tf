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

variable "psql_username" {
  description = "PostgreSQL username"
  type = string
  sensitive = true
}

variable "psql_password" {
  description = "PostgreSQL password"
  type = string
  sensitive = true
}

variable "psql_db_name" {
  description = "PostgreSQL database name"
  type = string
}

variable "psql_host" {
  description = "PostgreSQL host name address, like: psql.example.com"
  type = string
}

variable "psql_port" {
  description = "PostgreSQL port number"
  type = number
  default = 5432
}
