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
    iam_role_use_name_prefix = optional(bool, true)
    instance_types           = list(string)
    ami_type                 = string
    min_size                 = number
    max_size                 = number
    desired_size             = number
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
    }
  }
}
