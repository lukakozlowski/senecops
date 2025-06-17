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

# # PSQL # TODO: is not supported, possible but not recommended especially for production solution
# module "psql" {
#   source = "../modules/psql"
#
#   location = var.location
#   name     = local.name
#   db_name  = var.db_name
#   rg_name  = azurerm_resource_group.main.name
#   tags     = local.tags
# }

# MySQL # TODO: MariaDB is supported but not recommended, Azure decide to remove it from their offer, I could create a VM for that but decided to not spend so much time on that go get same result
module "mysql" {
  source = "../modules/mysql"

  location = var.location
  name     = local.name
  db_name  = var.db_name
  rg_name  = azurerm_resource_group.main.name
  tags     = local.tags
}

# Tools like: cert-manager, ingress-nginx, external-dns
module "tools" {
  source = "../modules/tools"

  cert_manager_ver      = "v1.16.4"
  ingress_nginx_ver     = "4.12.0"
  external_dns_ver      = "8.8.4"
  domain_name           = var.domain_name
  aws_access_key_id     = var.aws_access_key_id
  aws_access_key_secret = var.aws_access_key_secret

  depends_on = [
    module.aks
  ]
}

# TODO: it should be replaced with other provider which allows us to deploy it even if aks and cert-manager api is not available (during plan it fail) should be commented before deploy
# Cluster Issuer - Let's Encrypt
# resource "kubernetes_manifest" "cluster_issuer" {
#   manifest = yamldecode(templatefile("../manifests/cluster_issuer.yaml", {
#     email_address = "lkz@soyro-soft.com"
#   }))
#
#   depends_on = [
#     module.tools
#   ]
# }

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: lkz@spyro-soft.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
YAML

  depends_on = [
    module.tools
  ]
}

# Namespace - WordPress (or dedicated for general app usage)
resource "kubernetes_namespace" "app" {
  metadata {
    name = "wordpress"
  }

  depends_on = [
    module.aks
  ]
}

# WordPress
module "wordpress" {
  source = "../modules/wordpress"

  db_name       = var.db_name
  host          = module.mysql.host
  user          = module.mysql.user
  password      = module.mysql.password
  port          = module.mysql.port
  wordpress_ver = "24.0.1"
  domain_name   = "wp.${var.domain_name}"
  namespace     = "wordpress"

  depends_on = [
    module.aks,
    module.tools,
    # module.psql,
    module.mysql,
    kubernetes_namespace.app
  ]
}
