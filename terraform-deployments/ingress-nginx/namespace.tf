resource "kubernetes_namespace_v1" "test" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/instance" = var.controller_name
      "app.kubernetes.io/name"     = var.controller_name
    }
  }
}
