# CREATING A BUCKET
resource "digitalocean_spaces_bucket" "main" {
  name   = var.TRUSTUP_APP_KEY_SUFFIXED
  region = data.doppler_secrets.ci_commons.map.DIGITALOCEAN_CLUSTER_REGION

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

# CREATING A TLS PRVATE KEY REQUIRED BY TLS REQUEST
resource "tls_private_key" "main_bucket" {
  algorithm = "RSA"
}

# TLS REQUEST REQUIRED FOR CLOUDFLARE CERTIFICATE
resource "tls_cert_request" "main_bucket" {
  private_key_pem = tls_private_key.main_bucket.private_key_pem

  subject {
    common_name  = var.TRUSTUP_APP_KEY_SUFFIXED
    organization = "deegital"
  }
}

# CLOUDFLARE CERTIFICATE CREATION
resource "cloudflare_origin_ca_certificate" "main_bucket" {
  csr                = tls_cert_request.main_bucket.cert_request_pem
  hostnames          = [var.BUCKET_URL]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

# DIGITALOCEAN CERTIFICATE REGISTRATION BASED ON CLOUDFLARE CERTIFICATE
resource "digitalocean_certificate" "main_bucket" {
  name              = "${var.TRUSTUP_APP_KEY_SUFFIXED}-bucket-cert"
  type              = "custom"
  private_key       = tls_private_key.main_bucket.private_key_pem
  leaf_certificate  = cloudflare_origin_ca_certificate.main_bucket.certificate
}

# ADDING DNS RECORD MATCHING CERTIFICATE
resource "digitalocean_cdn" "main_bucket" {
  origin           = digitalocean_spaces_bucket.main.bucket_domain_name
  custom_domain    = var.BUCKET_URL
  certificate_name = digitalocean_certificate.main_bucket.name
}

# ADDING A CNAME RECORD TO CLOUDFLARE
resource "cloudflare_record" "main_bucket" {
  zone_id = lookup(data.doppler_secrets.ci_commons.map, var.CLOUDFLARE_ZONE_SECRET, data.doppler_secrets.ci_commons.map.CLOUDFLARE_DNS_ZONE_TRUSTUP_IO)
  name    = var.BUCKET_URL
  value = digitalocean_cdn.main_bucket.endpoint
  proxied = true
  type    = "CNAME"
}
