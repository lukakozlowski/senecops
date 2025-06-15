resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
    labels = {
      "cert-manager.io/disable-validation" = "true"
    }
  }
}

resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  namespace  = "ingress-nginx"
  version    = var.ingress_nginx_ver
  timeout    = 300

  set {
    name  = "controller.service.appProtocol"
    value = false
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os"
    value = "linux"
    type  = "string"
  }

  # set {
  #   name  = "controller.service.loadBalancerIP"
  #   type  = "string"
  #   value = var.ingress_ip_address
  # }
  #
  # set {
  #   name  = "controller.service.externalTrafficPolicy"
  #   type  = "string"
  #   value = "Local"
  # }
  #
  # set {
  #   name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
  #   type  = "string"
  #   value = var.ingress_domain_name_label
  # }

  depends_on = [
    kubernetes_namespace.ingress_nginx
  ]
}
