variable "DOPPLER_ACCESS_TOKEN_USER" {
  type = string
}

variable "DOCKER_IMAGE_TAG" {
  type = string
}

variable "TRUSTUP_APP_KEY_SUFFIXED" {
  type = string
}

variable "TRUSTUP_APP_KEY_SUFFIX" {
  type = string
}

variable "TRUSTUP_APP_KEY" {
  type = string
}

variable "APP_URL" {
  type = string
}

variable "BUCKET_URL" {
  type = string
}

variable "APP_ENVIRONMENT" {
  type = string
}

variable "CLOUDFLARE_ZONE_SECRET" {
  type = string
}

variable "IS_FALLBACK_DEPLOY" {
  type = bool
  default = false
}