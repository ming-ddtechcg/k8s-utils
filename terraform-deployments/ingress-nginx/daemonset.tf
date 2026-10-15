resource "kubernetes_daemon_set_v1" "this" {
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
    min_ready_seconds      = 0
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/component" = var.service_components_controller
        "app.kubernetes.io/instance"  = var.controller_name
        "app.kubernetes.io/name"      = var.controller_name
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = var.service_components_controller
          "app.kubernetes.io/instance"  = var.controller_name
          "app.kubernetes.io/name"      = var.controller_name
          "app.kubernetes.io/part-of"   = var.controller_name
          "app.kubernetes.io/version"   = var.service_version
        }
      }
      spec {
        host_network = true
        container {
          args = [
            "- /nginx-ingress-controller",
            "- --default-backend-service=$(POD_NAMESPACE)/${var.default_http_backend_name}",
            "- --election-id=ingress-nginx-leader",
            "- --controller-class=k8s.io/${var.controller_name}",
            "- --ingress-class=nginx",
            "- --configmap=$(POD_NAMESPACE)/${var.controller_name}",
            "- --validating-webhook=${var.controller_webhook_port}",
            "- --validating-webhook-certificate=/usr/local/certificates/cert",
            "- --validating-webhook-key=/usr/local/certificates/key",
            "- --enable-metrics=false",
            "- --annotations-prefix=nginx.ingress.kubernetes.io",
            "- --publish-service=$(POD_NAMESPACE)/${var.controller_name}"
          ]
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }
          image             = var.controller_image
          image_pull_policy = "IfNotPresent"
          lifecycle {
            pre_stop {
              exec {
                command = [
                  "- /wait-shutdown"
                ]
              }
            }
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = 10254
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          name = var.controller_name
          port {
            container_port = var.controller_http_port
            name           = var.controller_http_port_name
            protocol       = "TCP"
          }
          port {
            container_port = var.controller_https_port
            name           = var.controller_https_port_name
            protocol       = "TCP"
          }
          port {
            container_port = var.controller_webhook_port
            name           = var.controller_webhook_port_name
            protocol       = "TCP"
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = 10254
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          resources {
            requests = {
              cpu    = var.controller_resource_requests_cpu
              memory = var.controller_resource_requests_memory
            }
          }
          security_context {
            allow_privilege_escalation = true
            capabilities {
              add = [
                "- NET_BIND_SERVICE"
              ]
              drop = [
                "- ALL"
              ]
            }
            read_only_root_filesystem = false
            run_as_non_root           = false
            run_as_user               = 101
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
          volume_mount {
            mount_path = "/usr/local/certificates/"
            name       = "webhook-cert"
            read_only  = true
          }
        }

        dns_policy = "ClusterFirst"
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        service_account_name             = var.controller_name
        termination_grace_period_seconds = 300
        volume {
          name = "webhook-cert"
          secret {
            secret_name = var.admission_name
          }
        }
      }
    }
  }
}
