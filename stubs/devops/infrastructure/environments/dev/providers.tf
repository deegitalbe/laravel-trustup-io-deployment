provider "doppler" {
  doppler_token = var.DOPPLER_ACCESS_TOKEN_USER
}

data "doppler_secrets" "ci" {
  project = var.TRUSTUP_APP_KEY
  config = "ci"
}

