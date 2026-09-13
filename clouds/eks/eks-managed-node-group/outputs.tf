output "cluster_name" {
  description = "The Kubernetes cluster name <cluster-name>"
  value       = "${local.name}-cluster"
}

output "region" {
  description = "The Kubernetes cluster region <region>"
  value       = local.region
}

output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value	      = "aws eks update-kubeconfig --region <region> --name <cluster-name>"	
}

