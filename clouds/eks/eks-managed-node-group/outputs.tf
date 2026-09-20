output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}

