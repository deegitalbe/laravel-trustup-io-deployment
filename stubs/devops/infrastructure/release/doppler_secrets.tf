locals {
  DOPPLER_APP_CONFIG_NAME=replace(var.TRUSTUP_APP_KEY_SUFFIX == "" ? var.APP_ENVIRONMENT : var.TRUSTUP_APP_KEY_SUFFIX , "-", "_")
}

resource "doppler_secret" "deployed_image_tag" {
  project = var.TRUSTUP_APP_KEY
  config = local.DOPPLER_APP_CONFIG_NAME
  name = "DEPLOYED_IMAGE_TAG"
  value = var.DOCKER_IMAGE_TAG
}
