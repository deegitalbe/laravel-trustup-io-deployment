resource "kubernetes_job" "migrations" {
  depends_on = [
    kubernetes_secret.app_commons_token,
    kubernetes_secret.app_token,
    kubectl_manifest.doppler,
    kubectl_manifest.doppler_app_commons_secret,
    kubectl_manifest.doppler_app_secret,
    kubernetes_deployment.fpm
  ]
  metadata {
    annotations = local.app.commons.annotations
    labels = local.app.init.labels
    name = "migrations"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    template {
      metadata {
        labels = local.app.init.labels
      }
      spec {
        container {
          name = "migrations"
          image = replace(local.app.commons.docker.image, local.app.commons.docker.placeholder, local.app.cli.name)
          command = ["/bin/sh"]
          args = [
            "-c",
            "php artisan migrate --force",
          ]
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
        restart_policy = "Never"
      }
    }
    backoff_limit = 0
  }
  timeouts {
    create = "3m"
    update = "3m"
  }
}