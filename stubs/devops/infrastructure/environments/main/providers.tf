provider "doppler" {
  doppler_token = var.DOPPLER_SERVICE_TOKEN_TRUSTUP_IO_CI_COMMONS
  alias = "ci_commons"
}

provider "doppler" {
  doppler_token = doppler_service_token.local.key
  alias = "local"
}

data "doppler_secrets" "ci_commons" {
  provider = doppler.ci_commons
}

data "doppler_secrets" "local" {
  depends_on = [ doppler_environment.local ]
  provider = doppler.local
}

provider "doppler" {
  doppler_token = data.doppler_secrets.ci_commons.map.DOPPLER_ACCESS_TOKEN_USER
}