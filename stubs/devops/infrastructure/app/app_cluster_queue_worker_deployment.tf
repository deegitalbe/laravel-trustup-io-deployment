resource "kubernetes_deployment" "default_queue_worker" {
  depends_on = [
    kubernetes_secret.app_commons_token,
    kubernetes_secret.app_token,
    kubectl_manifest.doppler,
    kubectl_manifest.doppler_app_commons_secret,
    kubectl_manifest.doppler_app_secret
  ]
  metadata {
    namespace = kubernetes_namespace.app.metadata[0].name
    name = local.app.queue_worker.default.name
    labels = local.app.queue_worker.default.labels
    annotations = local.app.commons.annotations
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.app.queue_worker.default.labels
    }
    template {
      metadata {
        labels = local.app.queue_worker.default.labels
      }
      spec {
        container {
          name = local.app.queue_worker.default.name
          image = replace(local.app.commons.docker.image, local.app.commons.docker.placeholder, local.app.cli.name)
          command = ["php"]
          args = [
            "artisan",
            "horizon",
          ]
          port {
            container_port = 9000
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.app_commons_token.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.app_token.metadata[0].name
            }
          }
        }
      }
    }
  }
}