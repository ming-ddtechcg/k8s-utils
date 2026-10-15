resource "kubernetes_job_v1" "admission_create_job" {
  metadata {
    name = var.admission_create_name
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
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = var.service_components_controller
          "app.kubernetes.io/instance"  = var.controller_name
          "app.kubernetes.io/name"      = var.controller_name
          "app.kubernetes.io/part-of"   = var.controller_name
          "app.kubernetes.io/version"   = var.service_version
        }
        name = var.admission_create_name
      }
      spec {
        container {
          args = [
            "- create",
            "- --host=${var.admission_name},${var.admission_name}.$(POD_NAMESPACE).svc",
            "--namespace=$(POD_NAMESPACE)",
            "- --secret-name=${var.admission_name}"
          ]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = var.admission_create_image
          image_pull_policy = "IfNotPresent"
          name              = var.admission_create_name
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "- ALL"
              ]
            }
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 65532
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        restart_policy       = "OnFailure"
        service_account_name = var.admission_name
      }
    }
  }
}
