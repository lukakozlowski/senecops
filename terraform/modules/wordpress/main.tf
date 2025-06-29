# Generate - WordPress Password
resource "random_password" "wordpress" {
  length           = 32
  min_special      = 5
  override_special = "!#$%*()-_=+[]{}<>?"
}

# Database credentials
resource "kubernetes_secret" "db_wp_creds_secret" {
  metadata {
    name      = "db-wp-creds"
    namespace = var.namespace
  }

  data = {
    user     = base64encode(var.user)
    password = base64encode(var.password)
    host     = base64encode(var.host)
    database = base64encode(var.db_name)
    port     = base64encode(var.port)
  }

  type = "Opaque"
}

# WordPress
resource "helm_release" "wordpress" {
  name       = "wordpress"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  version    = var.wordpress_ver
  timeout    = 300

  values = [
    yamlencode({
      wordpressUsername = "senecops"
      wordpressPassword = sensitive(random_password.wordpress.result)
      wordpressEmail    = "lkz@spyro-soft.com" #TODO: could be general email address for IT department
      wordpressBlogName = "SenecOps"

      mariadb = {
        enabled = false
      }

      externalDatabase = {
        host     = var.host
        user     = sensitive(var.user)
        password = sensitive(var.password)
        database = var.db_name
        port     = var.port
        # existingSecret = kubernetes_secret.db_wp_creds_secret.metadata.0.name # TODO: next time :)
      }

      replicaCount : 3

      persistence = {
        enabled    = true
        accessMode = "ReadWriteMany"
        size       = "10Gi"
      }

      ingress = {
        enabled  = true
        hostname = var.domain_name
        ingressClassName : "nginx"
        pathType = "ImplementationSpecific"
        path     = "/"
        tls      = true

        annotations = {
          "cert-manager.io/cluster-issuer"            = "letsencrypt-prod"
          "kubernetes.io/ingress.class"               = "nginx"
          "nginx.ingress.kubernetes.io/use-regex"     = "true"
          "nginx.ingress.kubernetes.io/ssl-redirect"  = "true"
          "external-dns.alpha.kubernetes.io/hostname" = var.domain_name
        }
      }

      service = {
        type = "ClusterIP"
      }
    })
  ]

  depends_on = [
    # kubernetes_secret.db_wp_creds_secret
  ]
}
