# Main resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name}"
  location = var.location
  tags     = local.tags
}

# AKS
module "aks" {
  source = "../modules/aks"

  name             = local.name
  location         = var.location
  rg_name          = azurerm_resource_group.main.name
  aks_version      = "1.31.8"
  aks_node_vm_size = "Standard_B4ls_v2"
  tags             = local.tags
}

# PSQL
module "psql" {
  source = "../modules/psql"

  location = var.location
  name     = local.name
  db_name  = "wordpress"
  rg_name  = azurerm_resource_group.main.name
  tags     = local.tags
}

# Public IP address for Ingress-Nginx
resource "azurerm_public_ip" "pip_ingress" {
  allocation_method   = "Static"
  location            = var.location
  name                = "pip-ingress-${var.env_name}"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  domain_name_label   = "pip-ingress-${var.env_name}"

  tags = local.tags
}

# Tools like: cert-manager, ingress-nginx, external-dns
module "tools" {
  source = "../modules/tools"

  cert_manager_ver      = "v1.18.0"
  ingress_nginx_ver     = "4.12.3"
  external_dns_ver      = "8.8.4"
  domain_name           = var.domain_name
  aws_access_key_id     = var.aws_access_key_id
  aws_access_key_secret = var.aws_access_key_secret
  ingress_domain_name_label = azurerm_public_ip.pip_ingress.domain_name_label
  ingress_ip_address        = azurerm_public_ip.pip_ingress.ip_address

  depends_on = [
    module.aks
  ]
}

# Cluster Issuer - Let's Encrypt
resource "kubernetes_manifest" "cluster_issuer" {
  manifest = yamldecode(templatefile("../manifests/cluster_issuer.yaml", {
    email_address = "lkz@soyro-soft.com"
  }))

  depends_on = [
    module.tools
  ]
}

# Namespace - WordPress (or dedicated for general app usage)
resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = "wordpress"
  }

  depends_on = [
    module.aks
  ]
}

# WordPress App
module "wordpress" {
  source = "../modules/wordpress"

  psql_db_name  = module.psql.psql_db_name
  psql_host     = module.psql.psql_host
  psql_username = module.psql.psql_username
  psql_password = module.psql.psql_password
  wordpress_ver = "23.1.29"
  domain_name   = "wp.${var.domain_name}"
  namespace     = "wordpress"

  depends_on = [
    module.aks,
    module.tools,
    kubernetes_namespace.wordpress
  ]
}
