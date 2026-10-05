output "cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "eks_bastion_host" {
  description = "The bastion host access information for accessing the EKS nodes"
  value       = "${module.ec2_bastion.public_ip} - ${module.ec2_bastion.public_dns}"
}
