resource "kubernetes_validating_webhook_configuration_v1" "this" {
  metadata {
    name = var.admission_name
    labels = {
      "app.kubernetes.io/component" = var.service_components_controller
      "app.kubernetes.io/instance"  = var.controller_name
      "app.kubernetes.io/name"      = var.controller_name
      "app.kubernetes.io/part-of"   = var.controller_name
      "app.kubernetes.io/version"   = var.service_version
    }
  }
  webhook {
    admission_review_versions = ["v1"]
    client_config {
      service {
        namespace = var.namespace
        name      = var.admission_name
        path      = "/networking/v1/ingresses"
      }
    }
    failure_policy = "Fail"
    match_policy   = "Equivalent"
    name           = "validate.nginx.ingress.kubernetes.io"
    rule {
      api_groups   = ["networking.k8s.io"]
      api_versions = ["v1"]
      operations   = ["CREATE", "UPDATE"]
      resources    = ["ingresses"]
    }
    side_effects = "None"
  }
}
