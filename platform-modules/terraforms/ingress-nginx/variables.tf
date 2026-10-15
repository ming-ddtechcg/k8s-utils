variable "kubernetes_config_file" {
  type        = string
  description = "Kubernetes config path and file"
  #default     = "~/.kube/config.kubee-ubuntu-2204"
}

variable "kubernetes_config_context" {
  type        = string
  description = "Kubernetes config context"
  #default     = "kubernetes-admin@kubernetes"
}

# variable "host" {
#   type        = string
#   description = "Kubernetes api-server URL endpoint"
# }

# variable "client_certificate" {
#   type        = string
#   description = "Kubernetes api-server client certification"
# }

# variable "client_key" {
#   type        = string
#   description = "Kubernetes api-server client certifcation key"
# }

# variable "cluster_ca_certificate" {
#   type        = string
#   description = "Kubernetes cluster CA certification"
# }

variable "namespace" {
  type        = string
  description = "the namespace that the deployment stores"
  default     = "ingress-nginx"
}

variable "controller_name" {
  type        = string
  description = "nginx controller name"
  default     = "ingress-nginx"
}

variable "service_version" {
  type        = string
  description = "nginx service version"
  default     = "1.11.2"
}

variable "controller_http_port_name" {
  type        = string
  description = "nginx controller HTTP port name"
  default     = "http"
}

variable "controller_http_port" {
  type        = number
  description = "nginx controller HTTP port"
  default     = 80
}

variable "controller_https_port_name" {
  type        = string
  description = "nginx controller HTTPs port name"
  default     = "https"
}

variable "controller_https_port" {
  type        = number
  description = "nginx controller HTTP ports"
  default     = 443
}

variable "controller_webhook_port_name" {
  type        = string
  description = "nginx controller webhook port name"
  default     = "webhook"
}

variable "controller_webhook_port" {
  type        = number
  description = "nginx controller webhook ports"
  default     = 8443
}

variable "controller_image" {
  type        = string
  description = "nginx controller container image"
  default     = "harbor.ddtechcg.com:5001/k8s-utils/ingress-nginx-controller:v1.11.2"
}

variable "controller_resource_requests_cpu" {
  type        = string
  description = "nginx controller resoures requests cpu"
  default     = "100m"
}

variable "controller_resource_requests_memory" {
  type        = string
  description = "nginx controller resoures requests memory"
  default     = "90Mi"
}

variable "service_name" {
  type        = string
  description = "nginx service name"
  default     = "nginx"
}

variable "service_components_controller" {
  type        = string
  description = "nginx service compnents controller"
  default     = "controller"
}

variable "admission_name" {
  type        = string
  description = "nginx validating webhook admission name"
  default     = "ingress-nginx-admission"
}

variable "admission_create_name" {
  type        = string
  description = "nginx admission create job name"
  default     = "ingress-nginx-admission-create"
}

variable "admission_create_image" {
  type        = string
  description = "nginx admission create container image"
  default     = "harbor.ddtechcg.com:5001/k8s-utils/kube-webhook-certgen:v1.4.3"
}

variable "admission_patch_name" {
  type        = string
  description = "nginx admission patch job name"
  default     = "ingress-nginx-admission-patch"
}

variable "admission_patch_image" {
  type        = string
  description = "nginx admission patch container image"
  default     = "harbor.ddtechcg.com:5001/k8s-utils/kube-webhook-certgen:v1.4.3"
}

# ---

variable "default_http_backend_name" {
  type        = string
  description = "default http backend name"
  default     = "default-http-backend"
}

variable "default_http_backend_port" {
  type        = number
  description = "default http backend port"
  default     = 80
}

variable "default_http_backend_target_port" {
  type        = number
  description = "default http backend target port"
  default     = 8080
}

variable "default_http_backend_replicas" {
  type        = number
  description = "default http backend replicas"
  default     = 1
}

variable "default_http_backend_image" {
  type        = string
  description = "default http backend container image"
  default     = "harbor.ddtechcg.com:5001/k8s-utils/defaultbackend-amd64:1.5"
}

variable "default_http_backend_resource_limits_cpu" {
  type        = string
  description = "default http backend resoures limits cpu"
  default     = "10m"
}

variable "default_http_backend_resource_limits_memory" {
  type        = string
  description = "default http backend resoures limits memory"
  default     = "20Mi"
}

variable "default_http_backend_resource_requests_cpu" {
  type        = string
  description = "default http backend resoures requests cpu"
  default     = "10m"
}

variable "default_http_backend_resource_requests_memory" {
  type        = string
  description = "default http backend resoures requests memory"
  default     = "20Mi"
}
