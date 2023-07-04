resource "kubernetes_service"  "fpm" {
  metadata {
    namespace = kubernetes_namespace.app.metadata[0].name
    name = kubernetes_deployment.fpm.metadata[0].name
  }
  spec {
    selector = kubernetes_deployment.fpm.metadata[0].labels
    port {
      protocol = "TCP"
      port = 9000
      target_port = kubernetes_deployment.fpm.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}