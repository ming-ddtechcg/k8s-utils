resource "kubernetes_role_v1" "this" {
  metadata {
    name = var.controller_name
    labels = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
      "app.kubernetes.io/part-of"   = var.controller_name
      "app.kubernetes.io/version"   = var.service_version
    }
    namespace = var.namespace
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "endpoints", "services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses", "ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    resource_names = ["ingress-nginx-leader"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }
}

