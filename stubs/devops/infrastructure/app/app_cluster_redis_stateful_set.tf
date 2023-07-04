resource "kubernetes_stateful_set"  "redis" {
  metadata {
    namespace = kubernetes_namespace.app.metadata[0].name
    name = kubernetes_service.redis.metadata[0].name
    labels = kubernetes_service.redis.metadata[0].labels
  }
  spec {
    service_name = kubernetes_service.redis.metadata[0].name
    selector {
      match_labels = kubernetes_service.redis.metadata[0].labels
    }
    replicas = 1
    template {
      metadata {
        labels = kubernetes_service.redis.metadata[0].labels
      }
      spec {
        container {
          name = kubernetes_service.redis.metadata[0].name
          image = "redis:7.0.4"
          command = ["redis-server", "--appendonly", "yes"]
          port {
            name = "web"
            container_port = 6379
          }
          volume_mount {
            name = "redis-aof"
            mount_path = "/data"
          }
        }
        volume {
          name = "redis-aof"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.redis.metadata[0].name
          }
        }
      }
    }
  }
}