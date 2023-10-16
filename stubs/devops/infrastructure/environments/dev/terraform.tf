terraform {
  required_providers {
    doppler = {
      source = "DopplerHQ/doppler"
    }
  }
  backend "s3" {
    endpoint                    = "https://ams3.digitaloceanspaces.com"
    region                      = "ams3"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id = true
  }
  required_version = "~> 1.6.1"
}