output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

