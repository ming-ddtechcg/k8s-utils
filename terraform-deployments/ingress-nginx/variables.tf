variable "kubernetes_config_file" {
  type        = string
  description = "Kubernetes config path and file"
  # default     = "~/.kube/config.kubee-ubuntu-2204"
}

variable "kubernetes_config_context" {
  type        = string
  description = "Kubernetes config context"
  # default     = "kubernetes-admin@kubernetes"
}

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

variable "controller_http_ports_name" {
  type        = string
  description = "nginx controller HTTPs port name"
  default     = "https"
}

variable "controller_https_port" {
  type        = number
  description = "nginx controller HTTP ports"
  default     = 443
}

variable "service_components_controller" {
  type        = string
  description = "nginx service compnents controller"
  default     = "controller"
}

variable "admission_name" {
  type        = string
  description = "nginx webhook admission name"
  default     = "ingress-nginx-admission"
}

# ---

variable "container_image" {
  type        = string
  description = "container image"
  default     = "harbor.ddtechcg.com:5001/k8s-utils/ingress-nginx-controller:v1.11.2"
}