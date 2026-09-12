module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                                      = "${local.name}-cluster"
  kubernetes_version                        = "1.36"

  # Networking
  vpc_id                                    = module.vpc.vpc_id
  subnet_ids                                = module.vpc.private_subnets

  # Access configuration
  endpoint_public_access                    = true
  #endpoint_public_access_cidrs              = ["68.196.246.60/32"]
  endpoint_public_access_cidrs              = ["0.0.0.0/0"]
  enable_cluster_creator_admin_permissions  = true

  # EKS Addons
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_addons
  addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  # Specific Managed Node Groups Configuration
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.2.7/examples/eks_managed_node_group
  eks_managed_node_groups = {
    linux-micro-nodes = {
      name = "${local.name}-linux-micro-node"
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.micro"]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 2
      max_size = 4
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2
    }
    linux-small-nodes = {
      name = "${local.name}-linux-small-node"
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.small"]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 1
      max_size = 4
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1
    }
  }

  tags = local.tags
}
