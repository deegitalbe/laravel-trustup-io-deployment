terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.11"
    }
  }
  cloud {
    organization = "{{{{terraformCloudOrganizationName}}}}"

    workspaces {
      name = "{{{{environmentReadyAppKey}}}}"
    }
  }
}