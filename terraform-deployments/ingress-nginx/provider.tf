provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = var.kubernetes_config_context
}
