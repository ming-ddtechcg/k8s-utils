resource "kubernetes_service_v1" "this" {
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
  spec {
    selector = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
    }
    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"

    port {
      app_protocol = "http"
      name         = var.controller_http_port_name
      port         = var.controller_http_port
      target_port  = var.controller_http_port
      protocol     = TCP
    }
    port {
      app_protocol = "https"
      name         = var.controller_http_ports_name
      port         = var.controller_https_port
      target_port  = var.controller_https_port
      protocol     = TCP
    }

    type = "ClusterIP"
  }
}
