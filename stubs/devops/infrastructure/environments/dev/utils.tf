locals {
  # Retrieve environments from ci
  dev_related_environments_raw = nonsensitive(lookup(data.doppler_secrets.ci.map, "DEV_RELATED_ENVIRONMENTS", ""))
}

locals {
  # Split retrieved environments
  dev_related_environments_splitted = split(",", local.dev_related_environments_raw)
}

locals {
  # Add current environment (making sure it's not already in list)
  dev_related_environments_merged = distinct(concat(local.dev_related_environments_splitted, [var.DEV_ENVIRONMENT_TO_ADD]))
}

locals {
  # Remove current environment if needed
  dev_related_environments = compact([for name in local.dev_related_environments_merged : name == var.DEV_ENVIRONMENT_TO_REMOVE ? "" : name])
}

locals {
  dev_related_environments_stringified = local.dev_related_environments == [] ? "" : join(",", local.dev_related_environments)
}

locals {
  ci_commons = {
    project = data.doppler_secrets.ci_commons.map.DOPPLER_PROJECT
    config = data.doppler_secrets.ci_commons.map.DOPPLER_CONFIG
  }
}
