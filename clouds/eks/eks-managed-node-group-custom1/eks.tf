module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${local.name}-cluster"
  kubernetes_version = "1.36"

  # Networking
  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_public_ids
  #subnet_ids = local.subnet_private_ids

  # Access configuration
  endpoint_public_access = true
  #endpoint_public_access_cidrs            = ["68.196.246.60/32"]
  endpoint_public_access_cidrs             = ["0.0.0.0/0"]
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md#input_addons
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
    #eks-pod-identity-agent = {
    #  before_compute = true
    #}
  }

  # Specific Managed Node Groups Configuration
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.2.7/examples/eks_managed_node_group
  eks_managed_node_groups = {
    linux-small-nodes = {
      name                     = "${local.name}-linux-small-nodes"
      iam_role_use_name_prefix = false # terraform will not appends a unique suffix
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.small"]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 2
      max_size = 4
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2

      use_custom_launch_template = true       # required — key_name only applies via the launch template
      key_name                   = "eks-node" # goes directly on the launch template

      vpc_security_group_ids = [
        aws_security_group.node_ssh.id # SG with an ingress rule for port 22
      ]
    }
    linux-medium-nodes = {
      name                     = "${local.name}-linux-medium-nodes"
      iam_role_use_name_prefix = false # terraform will not appends a unique suffix
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.medium"]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 1
      max_size = 4
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2

      # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/3180#issuecomment-2446452416
      # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/compute_resources.md#eks-managed-node-groups
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      use_custom_launch_template = true       # required — key_name only applies via the launch template
      key_name                   = "eks-node" # goes directly on the launch template

      vpc_security_group_ids = [
        aws_security_group.node_ssh.id # SG with an ingress rule for port 22
      ]

      # the following will be conflict with block_device_mappings
      #   use_custom_launch_template = false
      #   remote_access = {
      #     ec2_ssh_key = "eks-node"
      #   }
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
    # ingress_ssh = {
    #   description = "SSH from bastion"
    #   protocol    = "tcp"
    #   from_port   = 22
    #   to_port     = 22
    #   type        = "ingress"
    #   cidr_blocks = ["10.0.0.0/16"]
    # }
  }

  tags = local.tags
}
