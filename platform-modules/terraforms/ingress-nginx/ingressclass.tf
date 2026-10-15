resource "kubernetes_ingress_class_v1" "ingress_nginx" {
  metadata {
    name = var.service_name
    labels = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
      "app.kubernetes.io/part-of"   = var.controller_name
      "app.kubernetes.io/version"   = var.service_version
    }
  }
  spec {
    controller = "k8s.io/${var.controller_name}"
  }
}
