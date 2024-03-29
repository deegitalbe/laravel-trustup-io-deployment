terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.11"
    }
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
  required_version = "~> 1.5.7"
}
