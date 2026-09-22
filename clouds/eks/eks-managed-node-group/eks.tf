module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.deployment_name}-cluster"
  kubernetes_version = var.kubernetes_version

  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Access configuration
  endpoint_public_access                   = var.endpoint_public_access
  endpoint_public_access_cidrs             = var.public_access_cidrs
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  # EKS Addons
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_addons
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
    # eks-pod-identity-agent uses the port 80 with the hostNetwork deployment
    #eks-pod-identity-agent = {
    #  before_compute = true
    #}
  }

  upgrade_policy = {
    support_type = var.upgrade_policy
  }

  # Specific Managed Node Groups Configuration
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.2.7/examples/eks_managed_node_group
  eks_managed_node_groups = {
    for key, node in var.eks_managed_nodes : key => {
      name                     = "${var.deployment_name}-${key}"
      iam_role_use_name_prefix = node.iam_role_use_name_prefix # terraform will/won't appends a unique suffix
      instance_types           = node.instance_types
      ami_type                 = node.ami_type

      min_size     = node.min_size
      max_size     = node.max_size
      desired_size = node.desired_size
    }
  }

  # add the addiitonal rules for the ingress controller if the controller will be installed
  node_security_group_additional_rules = {
    ingress_http = {
      description = "Allow HTTP from anywhere"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_https = {
      description = "Allow HTTPS from anywhere"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}
