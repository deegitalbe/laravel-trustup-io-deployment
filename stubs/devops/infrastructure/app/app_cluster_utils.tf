locals {
  app = {
    commons = {
      annotations = {
        "secrets.doppler.com/reload": "true"
      }
      docker: {
        placeholder = "{{name}}"
        image = "${data.doppler_secrets.ci_commons.map.DOCKERHUB_USERNAME}/${var.TRUSTUP_APP_KEY}-{{name}}:${var.DOCKER_IMAGE_TAG}"
      }
    }
    cron = {
      labels = {
        tier = "backend"
        layer = "cron"
      }
      name = "cron"
    }
    cli = {
      name = "cli"
    }
    fpm = {
      labels = {
        tier = "backend"
        layer = "fpm"
      }
      name = "fpm"
    }
    queue_worker = {
      default = {
        labels = {
          tier = "backend"
          layer = "queue-worker"
          queue = "default"
        }
        name = "queue-worker-default"
      }
    }
    redis = {
      labels = {
        tier = "backend"
        layer = "redis"
      }
      name = "redis"
    }
    webserver = {
      labels = {
        tier: "backend"
        layer: "webserver"
      }
      name = "webserver"
    }
  }
  doppler = {
    namespace = "doppler-operator-system"
    secrets = {
      same_as_suffixed_app_key = [
        "MAIL_FROM_NAME",
        "TRUSTUP_APP_KEY",
        "TRUSTUP_IO_APP_KEY",
        "TRUSTUP_MESSAGING_APP_KEY",
        "TRUSTUP_MODEL_BROADCAST_APP_KEY"
      ]
    }
  }
}