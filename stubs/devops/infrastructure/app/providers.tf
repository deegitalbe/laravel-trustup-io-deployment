provider "digitalocean" {
  token = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_ACCESS_TOKEN
  spaces_access_id  = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_SPACES_ACCESS_KEY_ID
  spaces_secret_key = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_SPACES_SECRET_ACCESS_KEY
}

provider "cloudflare" {
  api_key = data.doppler_secrets.ci_commons.map.CLOUDFLARE_API_TOKEN
  email = data.doppler_secrets.ci_commons.map.CLOUDFLARE_API_EMAIL
}

provider "doppler" {
  doppler_token = var.DOPPLER_SERVICE_TOKEN_TRUSTUP_IO_CI_COMMONS
  alias = "ci_commons"
}

data "doppler_secrets" "ci_commons" {
  provider = doppler.ci_commons
}

provider "doppler" {
  doppler_token = lookup(data.doppler_secrets.ci_commons.map, "DOPPLER_SERVICE_TOKEN_${replace(upper(var.TRUSTUP_APP_KEY), "-", "_")}_CI")
  alias = "app_ci"
}

data "doppler_secrets" "app_ci" {
  provider = doppler.app_ci
}

locals {
  DOPPLER_APP_SERVICE_TOKEN = lookup(data.doppler_secrets.app_ci.map, "DOPPLER_SERVICE_TOKEN_${replace(upper(local.DOPPLER_APP_CONFIG_NAME), "-", "_")}")
}

provider "doppler" {
  doppler_token = local.DOPPLER_APP_SERVICE_TOKEN
  alias = "app"
}

data "doppler_secrets" "app" {
  provider = doppler.app
}

provider "doppler" {
  doppler_token = data.doppler_secrets.ci_commons.map.DOPPLER_ACCESS_TOKEN_USER
}

provider "kubernetes" {
  host = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].host
  token = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].token

  client_certificate     = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].client_certificate)
  client_key             = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].cluster_ca_certificate)
}

provider "kubectl" {
  host = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].host
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].cluster_ca_certificate)
  token = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].token
  load_config_file = false
}

provider "helm" {
  kubernetes {
    host = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].host
    token = digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].token

    client_certificate     = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].client_certificate)
    client_key             = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.laravel-in-kubernetes.kube_config[0].cluster_ca_certificate)
  }
}