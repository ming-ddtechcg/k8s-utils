provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {
}

locals {
  name   = "test"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-2a","us-east-2b"]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.2"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway      = true
  single_nat_gateway      = false
  one_nat_gateway_per_az  = false


  tags = local.tags
}
