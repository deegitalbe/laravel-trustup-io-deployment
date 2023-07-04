data "kubernetes_service" "traefik" {
  depends_on = [helm_release.traefik]
  metadata {
    name = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
}

resource "cloudflare_record" "app" {
  depends_on = [helm_release.traefik]
  zone_id = lookup(data.doppler_secrets.ci_commons.map, var.CLOUDFLARE_ZONE_SECRET, data.doppler_secrets.ci_commons.map.CLOUDFLARE_DNS_ZONE_TRUSTUP_IO)
  name    = var.APP_URL
  value = data.kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].ip
  type    = "A"
  proxied = true
}