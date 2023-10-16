data "digitalocean_sizes" "database_cluster" {
  filter {
    key    = "vcpus"
    values = [local.is_production ? 1 : 1]
  }

  filter {
    key    = "memory"
    values = [local.is_production ? 1024 : 1024]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

locals {
  mysql = {
    engine = "mysql"
    version = "8"
  }
  allowed_ips = nonsensitive(split(",", data.doppler_secrets.ci_commons.map.DIGITALOCEAN_DATABASE_ALLOWED_IPS))
  database_cluster_size = "db-${element(data.digitalocean_sizes.database_cluster.sizes, 0).slug}"
}

resource "digitalocean_database_cluster" "laravel-in-kubernetes" {
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  engine = local.mysql.engine
  version = local.mysql.version
  size = local.database_cluster_size
  region = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_CLUSTER_REGION
  node_count = 1
  tags = local.tags
}

# Allowing database access for app cluster
resource "digitalocean_database_firewall" "laravel-in-kubernetes" {
  cluster_id = digitalocean_database_cluster.laravel-in-kubernetes.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.laravel-in-kubernetes.id
  }

  dynamic "rule" {
    for_each = toset(local.allowed_ips)

    content {
      type  = "ip_addr"
      value = rule.value
    }
  }
}

output "database_cluster_size" {
  value = local.database_cluster_size
}