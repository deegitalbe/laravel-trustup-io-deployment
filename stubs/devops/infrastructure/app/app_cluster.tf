data "digitalocean_kubernetes_versions" "kubernetes-version" {
  version_prefix = doppler_secret.kubernetes_version_prefix.value
}

data "digitalocean_sizes" "app_cluster" {
  filter {
    key    = "vcpus"
    # Scale up values
    values = [local.is_production ? 1 : 1]
  }

  filter {
    key    = "memory"
    # Scale up values
    values = [local.is_production ? 2048 : 2048]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

output "app_cluster_size" {
  value = "${element(data.digitalocean_sizes.app_cluster.sizes, 0).slug}"
}

output "app_cluster_version" {
  value = data.digitalocean_kubernetes_versions.kubernetes-version.latest_version
}

resource "digitalocean_kubernetes_cluster" "laravel-in-kubernetes" {
  # name = data.doppler_secrets.app.map.TRUSTUP_APP_KEY
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  region = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_CLUSTER_REGION

  # Latest patched version of DigitalOcean Kubernetes.
  # We do not want to update minor or major versions automatically.
  version = data.digitalocean_kubernetes_versions.kubernetes-version.latest_version

  # We want any Kubernetes Patches to be added to our cluster automatically.
  # With the version also set to the latest version, this will be covered from two perspectives
  auto_upgrade = true
  surge_upgrade = true
  maintenance_policy {
    # Run patch upgrades at 4AM on a Sunday morning.
    start_time = "04:00"
    day = "sunday"
  }
  tags = local.tags

  node_pool {
    name = var.TRUSTUP_APP_KEY_SUFFIXED
    size = "${element(data.digitalocean_sizes.app_cluster.sizes, 0).slug}"
    # We can autoscale our cluster according to use, and if it gets high,
    # We can auto scale to maximum 5 nodes.
    auto_scale = local.is_production ? true : false
    min_nodes = 1
    # Scale up values
    max_nodes = local.is_production ? 1 : 1

    # These labels will be available in the node objects inside of Kubernetes,
    # which we can use as taints and tolerations for workloads.
    labels = {
      pool = "default"
      size = "medium"
    }
    tags = local.tags
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}