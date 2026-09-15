output "cluster_name" {
  description = "The Kubernetes cluster name <cluster-name>"
  value       = module.eks.cluster_name
}

output "region" {
  description = "The Kubernetes cluster region <region>"
  value       = local.region
}

output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value	      = "aws eks update-kubeconfig --region <region> --name <cluster-name>"
}

output "nlb_dns_name" {
  description = "The public DNS name of the Network Load Balancer"
  value       = aws_lb.this.dns_name
}

