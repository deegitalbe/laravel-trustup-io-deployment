resource "doppler_config" "dev_related" {
  for_each = toset(local.dev_related_environments)
  name = replace(each.value, "-", "_")
  project = var.TRUSTUP_APP_KEY
  environment = "dev"
}