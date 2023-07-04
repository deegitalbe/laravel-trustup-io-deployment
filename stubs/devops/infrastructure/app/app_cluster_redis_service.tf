resource "kubernetes_service" "redis" {
  metadata {
    namespace = kubernetes_namespace.app.metadata[0].name
    name = local.app.redis.name
    labels = local.app.redis.labels
  }
  spec {
    selector = local.app.redis.labels
    port {
      protocol = "TCP"
      port = 6379
    }
    type = "ClusterIP"
  }
}