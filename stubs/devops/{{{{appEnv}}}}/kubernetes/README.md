# Deployment setup

## Terraform cloud

### Register workspace
- Create [{{{{appKey}}}} workspace](https://app.terraform.io/app/{{{{organizationName}}}}/workspaces/new)
- Add `trustup_io_app_key` variable with `{{{{appKey}}}}` value to your [workspace variables](https://app.terraform.io/app/{{{{organizationName}}}}/workspaces/{{{{appKey}}}}/variables)

### Create infrastructure
In your ``infrastructure`` folder run
```shell
terraform init && terraform apply
```

## Configure kubectl
``` shell
doctl kubernetes clusters list
```
``` shell
doctl kubernetes cluster kubeconfig save your_cluster_id_here
```

## Configure github secrets

### Create environments
You should configure ``production`` and ``staging`` [environments](https://github.com/{{{{githubOrganizationName}}}}/{{{{appKey}}}}/settings/environments) for your repository

### Save doctl cluster id to desired environment
```shell
DIGITALOCEAN_KUBERNETES_CLUSTER_ID=your_cluster_id_here
```

## Configure kubernetes cluster
In your ``kubernetes`` folder run
``` shell
kubectl create namespace traefik && kubectl create namespace app
```

### Traefik
``` shell
kubens traefik && kubectl apply -f traefik/cloudflare-secret.yml && helm repo add traefik https://helm.traefik.io/traefik && helm repo update && helm install traefik traefik/traefik --values=traefik/traefik-values.yml
```

### Register your domain to cloudflare
Get load balancer external IP address
``` shell
kubectl get all
```

Add a [DNS record](https://dash.cloudflare.com/) pointing to the external IP of your load balancer.

### Apply app configuration
``` shell
kubens app && kubectl apply -f app --recursive
```

### Reloader
``` shell
kubens default && kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
```
