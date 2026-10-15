resource "kubernetes_service_v1" "admission_service" {
  metadata {
    name = var.admission_name
    labels = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
      "app.kubernetes.io/part-of"   = var.controller_name
      "app.kubernetes.io/version"   = var.service_version
    }
    namespace = var.namespace
  }
  spec {
    selector = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
    }
    port {
      app_protocol = "https"
      name         = "${var.controller_https_port_name}-${var.controller_webhook_port_name}"
      port         = var.controller_https_port
      target_port  = var.controller_webhook_port
      protocol     = "TCP"
    }
    type = "ClusterIP"
  }
}
