resource "kubernetes_pod_disruption_budget_v1" "default_queue_worker" {
  metadata {
    name = kubernetes_deployment.default_queue_worker.metadata[0].name
    namespace = kubernetes_deployment.default_queue_worker.metadata[0].namespace
  }
  spec {
    min_available = 1
    selector {
      match_labels = kubernetes_deployment.default_queue_worker.metadata[0].labels
    }
  }
}