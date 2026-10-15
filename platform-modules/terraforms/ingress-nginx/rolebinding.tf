resource "kubernetes_role_binding_v1" "ingress_nginx" {
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
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.controller_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.controller_name
    namespace = var.namespace
  }
}
