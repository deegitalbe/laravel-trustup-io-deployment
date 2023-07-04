locals {
  mysql = {
    engine = "mysql"
    version = "8"
  }
}

resource "digitalocean_database_cluster" "laravel-in-kubernetes" {
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  engine = local.mysql.engine
  version = local.mysql.version
  size = "db-s-1vcpu-1gb"
  region = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_CLUSTER_REGION
  node_count = 1
}

# Allowing database access for app cluster
resource "digitalocean_database_firewall" "laravel-in-kubernetes" {
  cluster_id = digitalocean_database_cluster.laravel-in-kubernetes.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.laravel-in-kubernetes.id
  }
}