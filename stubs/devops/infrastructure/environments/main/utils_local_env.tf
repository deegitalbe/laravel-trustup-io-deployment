locals {
  local_app_key = "${var.TRUSTUP_APP_KEY}-local"
}

locals {
  dev_env = {
    TRUSTUP_APP_KEY = local.local_app_key
    TRUSTUP_IO_APP_KEY = local.local_app_key
    TRUSTUP_MESSAGING_APP_KEY = local.local_app_key
    TRUSTUP_MODEL_BROADCAST_APP_KEY = local.local_app_key
    APP_NAME = local.local_app_key
    APP_ENV = "local"
    APP_KEY = lookup(data.doppler_secrets.local.map, "APP_KEY", "base64:${base64sha256(var.TRUSTUP_APP_KEY)}")
    APP_DEBUG = "true"
    APP_URL = "https://${var.TRUSTUP_APP_KEY}.docker.localhost"
    VITE_APP_URL = "https://${var.TRUSTUP_APP_KEY}.docker.localhost"
    LOG_CHANNEL = "daily"
    LOG_DEPRECATIONS_CHANNEL = "null"
    LOG_LEVEL = "debug"
    APP_SERVICE = var.TRUSTUP_APP_KEY
    APP_PORT = lookup(data.doppler_secrets.local.map, "APP_PORT", data.doppler_secrets.ci_commons.map.LOCAL_APP_PORT)
    FORWARD_DB_PORT = lookup(data.doppler_secrets.local.map, "FORWARD_DB_PORT", data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_DB_PORT)
    FORWARD_REDIS_PORT = lookup(data.doppler_secrets.local.map, "FORWARD_REDIS_PORT", data.doppler_secrets.ci_commons.map.LOCAL_FORWARD_REDIS_PORT)
    VITE_PORT = lookup(data.doppler_secrets.local.map, "VITE_PORT", data.doppler_secrets.ci_commons.map.LOCAL_VITE_PORT)
    DB_CONNECTION = "mysql"
    DB_HOST = "${var.TRUSTUP_APP_KEY}-mysql"
    DB_PORT = "3306"
    DB_DATABASE = "${var.TRUSTUP_APP_KEY}-db"
    BROADCAST_DRIVER = "log"
    CACHE_DRIVER = "redis"
    FILESYSTEM_DISK = "local"
    QUEUE_CONNECTION = "redis"
    SESSION_DRIVER = "file"
    SESSION_LIFETIME = "120"
    MEMCACHED_HOST = "memcached"
    REDIS_HOST = "${var.TRUSTUP_APP_KEY}-redis"
    REDIS_PASSWORD = "null"
    REDIS_PORT = "6379"
    MAIL_MAILER = "smtp"
    MAIL_HOST = "${var.TRUSTUP_APP_KEY}-mailhog"
    MAIL_PORT = "1025"
    MAIL_USERNAME = "null"
    MAIL_PASSWORD = "null"
    MAIL_ENCRYPTION = "null"
    MAIL_FROM_NAME = local.local_app_key
    AWS_ACCESS_KEY_ID = ""
    AWS_SECRET_ACCESS_KEY = ""
    AWS_DEFAULT_REGION = "east-1"
    AWS_BUCKET = ""
    AWS_USE_PATH_STYLE_ENDPOINT = "false"
    SCOUT_DRIVER = "meilisearch"
    MEILISEARCH_HOST = "http://${var.TRUSTUP_APP_KEY}-meilisearch:7700"
  }
}