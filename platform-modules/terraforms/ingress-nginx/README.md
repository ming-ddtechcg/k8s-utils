# Ingress - nginx controller
Ingress nginx controller is the load balancer runs inside the Kubernetes environment to route HTTP/HTTPS traffic from the external to the internal services.

## Communication with the api-server

In order to communicate the Kubernetes api-server, the following two are examples.

### 1. with the Kubernetes configuration file

Enable the following setup with two tf files.

variables.tf:

```console
variable "kubernetes_config_file" {
  type        = string
  description = "Kubernetes config path and file"
  #default     = "~/.kube/config"
}

variable "kubernetes_config_context" {
  type        = string
  description = "Kubernetes config context"
  #default     = "kubernetes-admin@kubernetes"
}
```

provider.tf:

```console
provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = var.kubernetes_config_context
}
```

### 2. With the Kubernetes api-server endpoint and certs

Enable the following setup with two tf files.

variables.tf:

```console
variable "host" {
  type        = string
  description = "Kubernetes api-server URL endpoint"
}

variable "client_certificate" {
  type        = string
  description = "Kubernetes api-server client certification"
}

variable "client_key" {
  type        = string
  description = "Kubernetes api-server client certifcation key"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Kubernetes api-server client CA certification"
}
```

provider.tf:

```console
provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
```

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## References

- [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
- [Ingress - nginx controller with Helm Chart](https://github.com/ming-ddtechcg/k8s-utils/tree/main/applications/helm-charts/ingress-nginx)
- [Manage Kubernetes resources with Terraform](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider)
