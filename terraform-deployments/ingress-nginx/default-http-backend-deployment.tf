resource "kubernetes_deployment_v1" "default_http_backend" {
  metadata {
    name = var.default_http_backend_name
    labels = {
      app = var.default_http_backend_name
    }
    namespace = var.namespace
  }

  spec {
    replicas = var.default_http_backend_replicas

    selector {
      match_labels = {
        app = var.default_http_backend_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.default_http_backend_name
        }
      }

      spec {
        container {
          image = var.default_http_backend_image
          name  = var.default_http_backend_name

          port {
            container_port = var.default_http_backend_port
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = var.default_http_backend_resource_limits_cpu
              memory = var.default_http_backend_resource_limits_memory
            }
            requests = {
              cpu    = var.default_http_backend_resource_requests_cpu
              memory = var.default_http_backend_resource_requests_memory
            }
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = var.default_http_backend_port
              scheme = "HTTP"

            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
          }
        }
      }
    }
  }
}
