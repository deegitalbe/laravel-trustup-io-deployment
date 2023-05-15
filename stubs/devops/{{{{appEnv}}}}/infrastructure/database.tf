# Define some constant values for the different versions of DigitalOcean databases
locals {
  mysql = {
    engine = "mysql"
    version = "8"
  }
  postgres = {
    engine = "pg"
    version = "13" # Available options: 10 | 11 | 12 | 13
  }
}

# We need to create a database cluster in DigitalOcean,
# based on Mysql 8, which is the version DigitalOcean provides.
# You can switch this out for Postgres by changing the `locals.` pointer to point at postgres.
resource "digitalocean_database_cluster" "laravel-in-kubernetes" {
  name = var.trustup_io_app_key
  engine = local.mysql.engine # Replace with `locals.postgres.engine` if using postgres
  version = local.mysql.version # Replace with `locals.postgres.version` if using postgres
  size = "db-s-1vcpu-1gb"
  region = var.do_region
  node_count = 1
}

# We want to create a separate database for our application inside the database cluster.
# This way we can share the cluster resources, but have multiple separate databases.
resource "digitalocean_database_db" "laravel-in-kubernetes" {
  cluster_id = digitalocean_database_cluster.laravel-in-kubernetes.id
  name = "${var.trustup_io_app_key}-db"
}

# We want to create a separate user for our application,
# So we can limit access if necessary
# We also use Native Password auth, as it works better with current Laravel versions
resource "digitalocean_database_user" "laravel-in-kubernetes" {
  cluster_id = digitalocean_database_cluster.laravel-in-kubernetes.id
  name = "${var.trustup_io_app_key}-user"
}

# We want to allow access to the database from our Kubernetes cluster
# We can also add custom IP addresses
# If you would like to connect from your local machine,
# simply add your public IP
resource "digitalocean_database_firewall" "laravel-in-kubernetes" {
  cluster_id = digitalocean_database_cluster.laravel-in-kubernetes.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.laravel-in-kubernetes.id
  }

#   rule {
#     type  = "ip_addr"
#     value = "ADD_YOUR_PUBLIC_IP_HERE_IF_NECESSARY"
#   }
}

# We also need to add outputs for the database, to easily be able to reach it.

# Expose the host of the database so we can easily use that when connecting to it.
output "laravel-in-kubernetes-database-host" {
  value = digitalocean_database_cluster.laravel-in-kubernetes.host
}

# Expose the port of the database, as it is usually different from the default ports of Mysql / Postgres
output "laravel-in-kubernetes-database-port" {
  value = digitalocean_database_cluster.laravel-in-kubernetes.port
}

# Expose the port of the database, as it is usually different from the default ports of Mysql / Postgres
output "laravel-in-kubernetes-database-name" {
  value = digitalocean_database_db.laravel-in-kubernetes.name
}

# Expose the password of the database user
output "laravel-in-kubernetes-database-user-name" {
  value = digitalocean_database_user.laravel-in-kubernetes.name
}

# Expose the password of the database user
output "laravel-in-kubernetes-database-user-password" {
  value = digitalocean_database_user.laravel-in-kubernetes.password
  sensitive = true
}