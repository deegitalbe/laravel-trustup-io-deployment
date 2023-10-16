resource "kubernetes_pod_disruption_budget_v1" "webserver" {
  metadata {
    name = kubernetes_deployment.webserver.metadata[0].name
    namespace = kubernetes_deployment.webserver.metadata[0].namespace
  }
  spec {
    min_available = 1
    selector {
      match_labels = kubernetes_deployment.webserver.metadata[0].labels
    }
  }
}