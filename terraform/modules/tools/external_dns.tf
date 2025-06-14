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
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = var.external_dns_ver
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  create_namespace = false

  values = [
    <<-EOF
    provider: aws
    policy: sync
    zoneType: public

    txtOwnerId: external-dns
    domainFilters:
      - ${var.domain_name}

    env:
      - name: AWS_ACCESS_KEY_ID
        valueFrom:
          secretKeyRef:
            name: aws-credentials
            key: AWS_ACCESS_KEY_ID
      - name: AWS_SECRET_ACCESS_KEY
        valueFrom:
          secretKeyRef:
            name: aws-credentials
            key: AWS_SECRET_ACCESS_KEY
    EOF
  ]

  depends_on = [
    kubernetes_namespace.external_dns
  ]
}
