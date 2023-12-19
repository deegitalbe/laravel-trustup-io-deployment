resource "kubernetes_deployment" "webserver" {
  metadata {
    name = local.app.webserver.name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = local.app.webserver.labels
  }
  spec {
    replicas = 1
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = 1
        max_unavailable = 0
      }
    }
    selector {
      match_labels = local.app.webserver.labels
    }
    template {
      metadata {
        labels = local.app.webserver.labels
      }
      spec {
        container {
          name = local.app.webserver.name
          image = replace(local.app.commons.docker.image, local.app.commons.docker.placeholder, "web")
          port {
            container_port = 80
          }
          env {
            name = "FPM_HOST"
            value = "${kubernetes_service.fpm.metadata[0].name}:${kubernetes_service.fpm.spec[0].port[0].port}"
          }
        }
      }
    }
  }
  timeouts {
    create = "3m"
    update = "3m"
  }
}