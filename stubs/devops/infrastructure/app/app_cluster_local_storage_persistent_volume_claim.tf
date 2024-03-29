resource "kubernetes_persistent_volume_claim" "local_storage" {
  metadata {
    name = local.storage.local.claim.name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    storage_class_name = "do-block-storage"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage: local.is_production ? "5Gi" : "1Gi"
      }
    }
  }
}
