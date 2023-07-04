resource "doppler_service_token" "local" {
  project = doppler_project.app.name
  name = doppler_environment.local.name
  config = doppler_environment.local.slug
  access = "read"
}

resource "doppler_service_token" "dev" {
  project = doppler_project.app.name
  name = doppler_environment.dev.name
  config = doppler_environment.dev.slug
  access = "read"
}

resource "doppler_service_token" "staging" {
  project = doppler_project.app.name
  name = "staging"
  config = doppler_environment.staging.slug
  access = "read"
}

resource "doppler_service_token" "production" {
  project = doppler_project.app.name
  name = "production"
  config = doppler_environment.production.slug
  access = "read"
}

resource "doppler_service_token" "ci" {
  project = doppler_project.app.name
  name = "ci"
  config = doppler_environment.ci.slug
  access = "read"
}
