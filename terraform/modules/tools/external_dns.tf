resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret" "external_dns_aws_secret" {
  metadata {
    name      = "aws-credentials"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    AWS_ACCESS_KEY_ID     = base64encode(var.aws_access_key_id)
    AWS_SECRET_ACCESS_KEY = base64encode(var.aws_access_key_secret)
  }

  type = "Opaque"
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = "6.6.1" #var.external_dns_ver
  namespace        = kubernetes_namespace.external_dns.metadata[0].name
  create_namespace = false
  timeout          = 600

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "domainFilters[0]"
    value = var.domain_name
  }

  set {
    name  = "txtOwnerId"
    value = "external-dns"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "aws.credentials.secretKey"
    value = sensitive(var.aws_access_key_secret)
  }

  set {
    name  = "aws.credentials.accessKey"
    value = sensitive(var.aws_access_key_id)
  }

  # set {
  #   name  = "aws.credentials.secretName"
  #   value = "aws-credentials"
  # } # TODO: haven't enough time to fix that :)

  # set {
  #   name  = "aws.credentials.mountPath"
  #   value = "/.aws"
  # }

  depends_on = [
    kubernetes_namespace.external_dns,
    kubernetes_secret.external_dns_aws_secret
  ]
}
