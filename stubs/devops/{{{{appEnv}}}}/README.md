# Deployment setup

## Terraform cloud

### Register workspace

- Create [{{{{environmentReadyAppKey}}}} workspace](https://app.terraform.io/app/{{{{terraformCloudOrganizationName}}}}/workspaces/new)
- Add `trustup_io_app_key` variable with `{{{{environmentReadyAppKey}}}}` value to your [workspace variables](https://app.terraform.io/app/{{{{terraformCloudOrganizationName}}}}/workspaces/{{{{appKey}}}}/variables)

### Create infrastructure

In `devops/{{{{appEnv}}}}/infrastructure` folder run

```shell
terraform init && terraform apply
```

## Configure kubectl

```shell
doctl kubernetes clusters list
```

```shell
doctl kubernetes cluster kubeconfig save your_cluster_id_here
```

## Configure github secrets

### Create environment

Create [{{{{appEnv}}}} environment](https://github.com/{{{{githubOrganizationName}}}}/{{{{appKey}}}}/settings/environments) in your repository

### Save cluster id to your environment secrets

```shell
DIGITALOCEAN_KUBERNETES_CLUSTER_ID=clusted_id
```

## Configure kubernetes cluster

In `devops/{{{{appEnv}}}}/kubernetes` folder run

```shell
kubectl create namespace traefik && kubectl create namespace app
```

### Traefik

```shell
kubens traefik && kubectl apply -f traefik/cloudflare-secret.yml && helm repo add traefik https://helm.traefik.io/traefik && helm repo update && helm install traefik traefik/traefik --values=traefik/traefik-values.yml
```

### Register your domain to cloudflare

Get load balancer external IP address

```shell
kubectl get all
```

Add a [DNS record](https://dash.cloudflare.com) pointing to the external IP of your load balancer.

### Apply app configuration

```shell
kubens app && kubectl apply -f app --recursive
```

### Add reloader

```shell
kubens default && kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
```
