resource "kubernetes_pod_disruption_budget_v1" "fpm" {
  metadata {
    name = kubernetes_deployment.fpm.metadata[0].name
    namespace = kubernetes_deployment.fpm.metadata[0].namespace
  }
  spec {
    min_available = 1
    selector {
      match_labels = kubernetes_deployment.fpm.metadata[0].labels
    }
  }
}