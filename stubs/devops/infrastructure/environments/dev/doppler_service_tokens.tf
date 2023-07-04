resource "doppler_service_token" "dev_related" {
  for_each = doppler_config.dev_related
  project = var.TRUSTUP_APP_KEY
  name = each.value.name
  config = each.value.name
  access = "read"
}
