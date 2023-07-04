variable "DOPPLER_SERVICE_TOKEN_TRUSTUP_IO_CI_COMMONS" {
  type = string
}

variable "TRUSTUP_APP_KEY" {
  type = string
}

variable "DEV_ENVIRONMENT_TO_REMOVE" {
  type = string
  default = ""
}

variable "DEV_ENVIRONMENT_TO_ADD" {
  type = string
  default = ""
  sensitive = false
}
