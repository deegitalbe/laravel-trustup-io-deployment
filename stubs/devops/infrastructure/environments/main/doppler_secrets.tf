resource "doppler_secret" "ci_commons_app_ci_service_token" {
  project = data.doppler_secrets.ci_commons.map.DOPPLER_PROJECT
  config = data.doppler_secrets.ci_commons.map.DOPPLER_CONFIG
  name = "DOPPLER_SERVICE_TOKEN_${replace(upper(var.TRUSTUP_APP_KEY), "-", "_")}_CI"
  value = doppler_service_token.ci.key
}

resource "doppler_secret" "app_ci_local_service_tokens" {
  project = doppler_project.app.name
  config = doppler_environment.ci.slug
  name = "DOPPLER_SERVICE_TOKEN_LOCAL"
  value = doppler_service_token.local.key
}


resource "doppler_secret" "app_ci_dev_service_tokens" {
  project = doppler_project.app.name
  config = doppler_environment.ci.slug
  name = "DOPPLER_SERVICE_TOKEN_DEV"
  value = doppler_service_token.dev.key
}

resource "doppler_secret" "app_ci_staging_service_tokens" {
  project = doppler_project.app.name
  config = doppler_environment.ci.slug
  name = "DOPPLER_SERVICE_TOKEN_STAGING"
  value = doppler_service_token.staging.key
}

resource "doppler_secret" "app_ci_production_service_tokens" {
  project = doppler_project.app.name
  config = doppler_environment.ci.slug
  name = "DOPPLER_SERVICE_TOKEN_PRODUCTION"
  value = doppler_service_token.production.key
}

resource "doppler_secret" "ci_commons_local_app_port" {
  project = local.ci_commons.project
  config = local.ci_commons.config
  name = "LOCAL_APP_PORT"
  value = data.doppler_secrets.ci_commons.map.LOCAL_APP_PORT == local.dev_env.APP_PORT ? sum([data.doppler_secrets.ci_commons.map.LOCAL_APP_PORT, 1]) : data.doppler_secrets.ci_commons.map.LOCAL_APP_PORT
}

resource "doppler_secret" "ci_commons_local_forward_db_port" {
  project = local.ci_commons.project
  config = local.ci_commons.config
  name = "LOCAL_FORWARD_DB_PORT"
  value = data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_DB_PORT == local.dev_env.FORWARD_DB_PORT ? sum([data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_DB_PORT, 1]) : data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_DB_PORT
}

resource "doppler_secret" "ci_commons_local_forward_redis_port" {
  project = local.ci_commons.project
  config = local.ci_commons.config
  name = "LOCAL_FORWARD_REDIS_PORT"
  value = data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_REDIS_PORT == local.dev_env.FORWARD_REDIS_PORT ? sum([data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_REDIS_PORT, 1]) : data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_REDIS_PORT
}

resource "doppler_secret" "ci_commons_local_vite_port" {
  project = local.ci_commons.project
  config = local.ci_commons.config
  name = "LOCAL_VITE_PORT"
  value = data.doppler_secrets.ci_commons.map.LOCAL_VITE_PORT == local.dev_env.VITE_PORT ? sum([data.doppler_secrets.ci_commons.map.LOCAL_VITE_PORT, 1]) : data.doppler_secrets.ci_commons.map.LOCAL_VITE_PORT
}

resource "doppler_secret" "local_environment_secrets" {
  for_each = local.dev_env
  project = doppler_project.app.name
  config = doppler_environment.local.slug
  name = each.key
  value = each.value
}

# resource "time_sleep" "local_environment_secrets" {
#   depends_on = [ doppler_secret.local_environment_secrets ]
#   create_duration = "60s"
# }

resource "doppler_secret" "dev_environment_secrets" {
  # depends_on = [ time_sleep.local_environment_secrets ]
  depends_on = [ doppler_secret.local_environment_secrets ]
  for_each = local.default_env
  project = doppler_project.app.name
  config = doppler_environment.dev.slug
  name = each.key
  value = each.value
}

resource "time_sleep" "dev_environment_secrets" {
  depends_on = [ doppler_secret.dev_environment_secrets ]
  create_duration = "60s"
}

resource "doppler_secret" "staging_environment_secrets" {
  depends_on = [ time_sleep.dev_environment_secrets ]
  # depends_on = [ doppler_secret.dev_environment_secrets ]
  for_each = local.default_env
  project = doppler_project.app.name
  config = doppler_environment.staging.slug
  name = each.key
  value = each.value
}

# resource "time_sleep" "staging_environment_secrets" {
#   depends_on = [ doppler_secret.staging_environment_secrets ]
#   create_duration = "60s"
# }

resource "doppler_secret" "production_environment_secrets" {
  # depends_on = [ time_sleep.staging_environment_secrets ]
  depends_on = [ doppler_secret.staging_environment_secrets ]
  for_each = local.default_env
  project = doppler_project.app.name
  config = doppler_environment.production.slug
  name = each.key
  value = each.value
}
