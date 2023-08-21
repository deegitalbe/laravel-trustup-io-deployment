resource "doppler_secret" "app_ci_dev_related_environments" {
  project = var.TRUSTUP_APP_KEY
  config = "ci"
  name = "DEV_RELATED_ENVIRONMENTS"
  value = local.dev_related_environments_stringified
}
