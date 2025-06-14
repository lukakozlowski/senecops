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

# Tools like: cert-manager, ingress-nginx, external-dns
module "tools" {
  source = "../modules/tools"

  cert_manager_ver      = "v1.18.0"
  ingress_nginx_ver     = "4.12.3"
  external_dns_ver      = "1.16.1"
  domain_name           = var.domain_name
  aws_access_key_id     = var.aws_access_key_id
  aws_access_key_secret = var.aws_access_key_secret

  depends_on = [
    module.aks
  ]
}


module "wordpress" {
  source = "../modules/wordpress"

  psql_db_name  = module.psql.psql_db_name
  psql_host     = module.psql.psql_host
  psql_username = module.psql.psql_username
  psql_password = module.psql.psql_password
  wordpress_ver = "23.1.29"
  domain_name   = "wp.${var.domain_name}"
  namespace     = "wordpress"
}
