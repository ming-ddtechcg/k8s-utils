resource "kubernetes_deployment_v1" "test" {
  metadata {
    name = var.deployment_name
    labels = {
      app = var.deployment_name
    }
    namespace = var.namespace
  }

  spec {
    replicas = var.pod_replica_number

    selector {
      match_labels = {
        app = var.deployment_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_name
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.deployment_name

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
