resource "kubectl_manifest" "doppler_traefik_secret" {
  depends_on = [ kubernetes_secret.ci_commons_token ]
  yaml_body = file("manifests/doppler/secrets/traefik/secret.yml")
}

resource "kubectl_manifest" "doppler_app_commons_secret" {
  depends_on = [ kubernetes_secret.app_commons_token ]
  yaml_body = file("manifests/doppler/secrets/app/commons-secret.yml")
}

resource "kubectl_manifest" "doppler_app_secret" {
  depends_on = [ kubernetes_secret.app_token ]
  yaml_body = file("manifests/doppler/secrets/app/secret.yml")
}

