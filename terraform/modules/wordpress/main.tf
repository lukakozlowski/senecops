# Generate - WordPress Password
resource "random_password" "wordpress" {
  length           = 32
  min_special      = 5
  override_special = "!#$%&*()-_=+[]{}<>?"
}

# PSQL - Database credentials
resource "kubernetes_secret" "psql_wp_creds_secret" {
  metadata {
    name = "psql-wp-creds"
    namespace = var.namespace
  }

  data = {
    username = base64encode(var.psql_username)
    password = base64encode(var.psql_password)
    host     = base64encode(var.psql_host)
    database = base64encode(var.psql_db_name)
  }

  type = "Opaque"
}

# WordPress
resource "helm_release" "wordpress" {
  name       = "wordpress"
  namespace = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = var.wordpress_ver
  timeout    = 600

  values = [
    yamlencode({
      wordpressUsername = "senecops"
      wordpressPassword = random_password.wordpress.result
      wordpressEmail    = "lkz@spyro-soft.com" #TODO: could be general email address for IT department
      wordpressBlogName = "SenecOps"

      # mariadb = {
      #   enabled = false
      # }
      #
      externalDatabase = {
        host     = var.psql_host
        port     = var.psql_port
        user     = var.psql_username
        password = var.psql_password
        database = var.psql_db_name
        # existingSecret = kubernetes_secret.psql_wp_creds_secret.metadata.0.name
      }

      # replicaCount: 3

      ingress = {
        enabled = true
        hostname = var.domain_name
        ingressClassName: "nginx"
        pathType = "ImplementationSpecific"
        path = "/"
        tls = true

        annotations = {
          "cert-manager.io/cluster-issuer"              = "letsencrypt-prod"
          "kubernetes.io/ingress.class"                 = "nginx"
          "nginx.ingress.kubernetes.io/use-regex"       = "true"
          "nginx.ingress.kubernetes.io/ssl-redirect"    = "true"
          "external-dns.alpha.kubernetes.io/hostname"   = var.domain_name
        }
      }

      # persistence = {
      #   enabled = true
      #   storageClass = ""
      #   size    = "10Gi"
      #   accessMode: "ReadWriteMany"
      # }

      service = {
        type = "ClusterIP"
      }
    })
  ]

  depends_on = [
    kubernetes_secret.psql_wp_creds_secret
  ]
}
