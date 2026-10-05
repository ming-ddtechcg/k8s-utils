variable "deployment_name" {
  type        = string
  description = "The name of the EKS deployment"
  #default     = "test"
}

variable "region" {
  description = "Region for the deployment"
  type        = string
  default     = "us-east-2"
}

variable "azs" {
  description = "Availability zones for the deployment"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

# Network

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Allow a NAT gateway to enable access from private subnets to the internet."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Set a single shared NAT Gateway across all of private subnets."
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Set a single NAT Gateway per availability zone."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enable the DNS support in VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable the DNS hostname support in VPC."
  type        = bool
  default     = true
}


# EKS

variable "kubernetes_version" {
  type        = string
  description = "The version of the Kubernetes"
  default     = "1.36"
}

variable "endpoint_public_access" {
  description = "Expose the Kubernetes API endpoint publicly so kubectl can reach from outside the VPC."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allows to reach the public API endpoint."
  type        = list(string)
  # default     = ["68.196.246.60/32"]
  default = ["0.0.0.0/0"]
}

variable "enable_cluster_creator_admin_permissions" {
  description = "whether or not to add the cluster creator as an administrator via access entry."
  type        = bool
  default     = true
}

variable "upgrade_policy" {
  description = "The cluster upgrade policy in either EXTENDED or STANDARD"
  type        = string
  default     = "STANDARD"
}

variable "eks_managed_nodes" {
  description = "The node definitions in the EKS managed node groups"
  type = map(object({
    iam_role_use_name_prefix   = optional(bool, true)
    instance_types             = list(string)
    ami_type                   = string
    min_size                   = number
    max_size                   = number
    desired_size               = number
    use_custom_launch_template = optional(bool, true)
    key_name                   = optional(string)
    has_vpc_security_group_ids = optional(bool, false)
    block_device_mappings = optional(map(object({
      device_name = string
      ebs = object({
        volume_size           = number
        volume_type           = optional(string)
        iops                  = optional(number)
        throughput            = optional(number)
        encrypted             = optional(bool, true)
        delete_on_termination = optional(bool, true)
      })
    })), {})
  }))
  default = {
    linux-micro-nodes = {
      iam_role_use_name_prefix = false
      instance_types           = ["t3.micro"]
      ami_type                 = "AL2023_x86_64_STANDARD"
      min_size                 = 2
      max_size                 = 4
      desired_size             = 2
    }
    linux-medium-nodes = {
      iam_role_use_name_prefix = false
      instance_types           = ["t3.medium"]
      ami_type                 = "AL2023_x86_64_STANDARD"
      min_size                 = 1
      max_size                 = 4
      desired_size             = 1

      use_custom_launch_template = true
      key_name                   = "eks-node"
      has_vpc_security_group_ids = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 100
            volume_type = "gp3"
          }
        }
      }
    }
  }
}

# EKS node bastion

variable "eks_node_bastion" {
  description = "A bastion to access the EKS nodes"
  type = object({
    instance_type               = string
    key_name                    = optional(string)
    monitoring                  = optional(bool, true)
    associate_public_ip_address = optional(bool)
    create_security_group       = optional(bool, false)
  })
  default = {
    instance_type               = "t3.micro"
    associate_public_ip_address = true
    key_name                    = "mybastion"
  }
}
