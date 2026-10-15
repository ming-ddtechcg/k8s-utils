resource "kubernetes_service_v1" "default_http_backend" {
  metadata {
    name = var.default_http_backend_name
    labels = {
      app = var.default_http_backend_name
    }
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.default_http_backend_name
    }
    port {
      port        = var.default_http_backend_port
      target_port = var.default_http_backend_target_port
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
