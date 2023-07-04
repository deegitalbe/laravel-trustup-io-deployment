provider "doppler" {
  doppler_token = var.DOPPLER_SERVICE_TOKEN_TRUSTUP_IO_CI_COMMONS
  alias = "ci_commons"
}

data "doppler_secrets" "ci_commons" {
  provider = doppler.ci_commons
}

provider "doppler" {
  doppler_token = lookup(data.doppler_secrets.ci_commons.map, "DOPPLER_SERVICE_TOKEN_${replace(upper(var.TRUSTUP_APP_KEY), "-", "_")}_CI")
  alias = "ci"
}

data "doppler_secrets" "ci" {
  provider = doppler.ci
}

provider "doppler" {
  doppler_token = data.doppler_secrets.ci_commons.map.DOPPLER_ACCESS_TOKEN_USER
}