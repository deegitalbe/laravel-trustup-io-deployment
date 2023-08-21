resource "doppler_service_token" "ci_commons" {
  project = "trustup-io-ci-commons"
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  config = "github"
  access = "read"
}

resource "doppler_service_token" "app_commons" {
  project = "trustup-io-app-commons"
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  config = var.APP_ENVIRONMENT
  access = "read"
}

resource "doppler_service_token" "app" {
  project = var.TRUSTUP_APP_KEY
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  config = local.DOPPLER_APP_CONFIG_NAME
  access = "read"
}
