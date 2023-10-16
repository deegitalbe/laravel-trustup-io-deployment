resource "kubernetes_pod_disruption_budget_v1" "redis" {
  metadata {
    name = kubernetes_service.redis.metadata[0].name
    namespace = kubernetes_service.redis.metadata[0].namespace
  }
  spec {
    min_available = 1
    selector {
      match_labels = kubernetes_service.redis.metadata[0].labels
    }
  }
}