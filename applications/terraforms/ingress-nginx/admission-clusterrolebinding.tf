resource "kubernetes_cluster_role_binding_v1" "admission_clusterrolebinding" {
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
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.admission_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.admission_name
    namespace = var.namespace
  }
}
