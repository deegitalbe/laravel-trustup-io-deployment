resource "kubernetes_deployment" "fpm" {
  depends_on = [
    kubernetes_secret.app_commons_token,
    kubernetes_secret.app_token,
    kubectl_manifest.doppler,
    kubectl_manifest.doppler_app_commons_secret,
    kubectl_manifest.doppler_app_secret
  ]
  metadata {
    annotations = local.app.commons.annotations
    labels = local.app.fpm.labels
    name = local.app.fpm.name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = 4
        max_unavailable = 0
      }
    }
    selector {
      match_labels = local.app.fpm.labels
    }
    template {
      metadata {
        labels = local.app.fpm.labels
      }
      spec {
        # CREATING FRAMEWORK REQUIRED STORAGE FOLDERS AND CACHING
        init_container {
          name = "cache"
          image = replace(local.app.commons.docker.image, local.app.commons.docker.placeholder, local.app.cli.name)
          command = ["/bin/sh"]
          args = [
            "-c",
            "php artisan event:cache && php artisan route:cache && php artisan view:cache"
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
        container {
          name = local.app.fpm.name
          image = replace(local.app.commons.docker.image, local.app.commons.docker.placeholder, local.app.fpm.name)
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
          port {
            container_port = 9000
          }
        }
      }
    }
  }
  timeouts {
    create = "5m"
    update = "5m"
  }
}