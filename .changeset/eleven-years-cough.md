---
"@deegital/laravel-trustup-io-deployment": patch
---

Workaround for bucket DNS error. For unknown reason, digitalocean refuses cloudflare dns certificates. We have to execute a doctl command to magically let digitalocean autogenerate certificate.
