provider "doppler" {
  doppler_token = var.DOPPLER_ACCESS_TOKEN_USER
}

data "doppler_secrets" "ci_commons" {
  project = "trustup-io-ci-commons"
  config = "github"
}

data "doppler_secrets" "local" {
  depends_on = [ doppler_environment.local ]
  project = var.TRUSTUP_APP_KEY
  config = "local"
}
