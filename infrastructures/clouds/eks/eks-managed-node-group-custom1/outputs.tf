output "vpc_id" {
  value = local.vpc_id
}

output "vpc_cidr" {
  value = local.vpc_cidr
}

output "azs" {
  value = local.azs
}

output "subnet_private_ids" {
  value = local.subnet_private_ids
}

output "aws_cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration update"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}

