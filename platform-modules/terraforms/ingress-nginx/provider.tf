provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = var.kubernetes_config_context
}

# provider "kubernetes" {
#   host = var.host
#
#   client_certificate     = base64decode(var.client_certificate)
#   client_key             = base64decode(var.client_key)
#   cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
# }
