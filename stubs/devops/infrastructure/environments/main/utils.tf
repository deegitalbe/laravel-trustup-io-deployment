locals {
  ci_commons = {
    project = data.doppler_secrets.ci_commons.map.DOPPLER_PROJECT
    config = data.doppler_secrets.ci_commons.map.DOPPLER_CONFIG
  }
}
