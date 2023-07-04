locals {
  TRAEFIK_TLS_STORE_SECRET_NAME = "traefik-tls-cert"
}

# CREATING A TLS PRVATE KEY REQUIRED BY TLS REQUEST
resource "tls_private_key" "app_cluster" {
  algorithm = "RSA"
}

# TLS REQUEST REQUIRED FOR CLOUDFLARE CERTIFICATE
resource "tls_cert_request" "app_cluster" {
  private_key_pem = tls_private_key.app_cluster.private_key_pem

  subject {
    common_name  = "${var.TRUSTUP_APP_KEY_SUFFIXED}-app"
    organization = "deegital"
  }
}

# CLOUDFLARE CERTIFICATE CREATION
resource "cloudflare_origin_ca_certificate" "app_cluster" {
  csr                = tls_cert_request.app_cluster.cert_request_pem
  hostnames          = [var.APP_URL]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

locals {
  APP_NAMESPACES_REQUIRING_SSL_CERTIFICATES = [
    "default",
    kubernetes_namespace.app.metadata[0].name,
    kubernetes_namespace.traefik.metadata[0].name
  ]
}

resource "kubernetes_secret" "traefik_certificates" {
  depends_on = [ cloudflare_origin_ca_certificate.app_cluster ]
  for_each = toset(local.APP_NAMESPACES_REQUIRING_SSL_CERTIFICATES)
  type = "Opaque"
  metadata {
    name = local.TRAEFIK_TLS_STORE_SECRET_NAME
    namespace = each.value
  }
  data = {
    "tls.key" = tls_private_key.app_cluster.private_key_pem
    "tls.crt" = cloudflare_origin_ca_certificate.app_cluster.certificate
  }
}

resource "helm_release" "traefik" {
  depends_on = [
    kubernetes_secret.ci_commons_token,
    kubectl_manifest.doppler,
    kubectl_manifest.doppler_traefik_secret,
    kubernetes_secret.traefik_certificates
  ]
  namespace = kubernetes_namespace.traefik.metadata[0].name
  create_namespace = true
  name = "traefik"
  repository = "https://traefik.github.io/charts"
  chart = "traefik"
  wait = true
  timeout = 800
  values = [file("charts/traefik/values.yml")]
}