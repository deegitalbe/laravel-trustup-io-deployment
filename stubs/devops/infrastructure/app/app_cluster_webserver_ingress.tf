resource "kubernetes_ingress_v1" "webserver" {
  metadata {
    namespace = kubernetes_namespace.app.metadata[0].name
    name = kubernetes_service.webserver.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class": "traefik"
    }
    labels = kubernetes_deployment.webserver.metadata[0].labels
  }
  spec {
    rule {
      host = cloudflare_record.app.hostname
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.webserver.metadata[0].name
              port {
                number = kubernetes_service.webserver.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}