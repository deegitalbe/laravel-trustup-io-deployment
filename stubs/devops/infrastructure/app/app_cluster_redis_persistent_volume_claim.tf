resource "kubernetes_persistent_volume_claim" "redis" {
  metadata {
    name = local.app.redis.name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    storage_class_name = "do-block-storage"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage: "1Gi"
      }
    }
  }
}