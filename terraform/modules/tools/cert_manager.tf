resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_ver
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
  timeout = 300

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}
