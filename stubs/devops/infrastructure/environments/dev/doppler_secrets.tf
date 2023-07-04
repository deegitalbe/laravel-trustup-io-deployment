resource "doppler_secret" "app_ci_dev_related_environments" {
  project = var.TRUSTUP_APP_KEY
  config = "ci"
  name = "DEV_RELATED_ENVIRONMENTS"
  value = local.dev_related_environments_stringified
}

resource "doppler_secret" "app_ci_dev_related_service_tokens" {
  for_each = doppler_service_token.dev_related
  project = var.TRUSTUP_APP_KEY
  config = "ci"
  name = "DOPPLER_SERVICE_TOKEN_${replace(upper(each.value.name), "-", "_")}"
  value = each.value.key
}
