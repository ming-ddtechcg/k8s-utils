output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "azs" {
  value = module.vpc.azs
}

output "subnet_private_ids" {
  value = module.vpc.private_subnets
}

output "aws_cluster_admin_kubeconfig" {
  description = "The Kubernetes cluster administrator configuration update"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}

