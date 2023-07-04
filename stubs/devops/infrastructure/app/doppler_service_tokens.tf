locals {
    DOPPLER_TRUSTUP_IO_APP_COMMONS_PROJECT = "trustup-io-app-commons"
}

resource "doppler_service_token" "app_commons" {
  project = local.DOPPLER_TRUSTUP_IO_APP_COMMONS_PROJECT
  name = var.TRUSTUP_APP_KEY_SUFFIXED
  config = var.APP_ENVIRONMENT
  access = "read"
}