output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}

output "nlb_dns_name" {
  description = "The public DNS name of the Network Load Balancer"
  value       = aws_lb.this.dns_name
}

