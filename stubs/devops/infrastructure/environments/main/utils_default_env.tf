locals {
  default_env = {
    BROADCAST_DRIVER = "log"
    CACHE_DRIVER = "redis"
    DB_CONNECTION = "mysql"
    FILESYSTEM_DISK = "s3"
    LOG_CHANNEL = "flare"
    LOG_DEPRECATIONS_CHANNEL = "null"
    LOG_LEVEL = "debug"
    MAIL_ENCRYPTION = "null"
    MAIL_HOST = "mailhog"
    MAIL_MAILER = "smtp"
    MAIL_PASSWORD = ""
    MAIL_PORT = "1025"
    MAIL_USERNAME = ""
    MEILISEARCH_HOST = "http://meilisearch:7700"
    QUEUE_CONNECTION = "redis"
    REDIS_HOST = "redis"
    REDIS_PORT = "6379"
    SCOUT_DRIVER = "meilisearch"
    SESSION_DRIVER = "redis"
    SESSION_LIFETIME = "120"
  }
}