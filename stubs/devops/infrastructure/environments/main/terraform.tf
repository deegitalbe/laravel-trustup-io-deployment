terraform {
  required_providers {
    doppler = {
      source = "DopplerHQ/doppler"
    }
  }
  backend "s3" {
    endpoint                    = "ams3.digitaloceanspaces.com"
    region                      = "ams3"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}