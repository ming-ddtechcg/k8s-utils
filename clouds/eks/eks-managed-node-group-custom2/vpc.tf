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

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  tags = local.tags
}

# module "endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "~> 6.7"

#   vpc_id             = module.vpc.vpc_id
#   security_group_ids = [aws_security_group.node_ssh.id]

#   endpoints = {
#     # Gateway Endpoint (SSH)
#     ssh = {
#       service      = "ssh"
#       service_type = "Gateway"
#       route_table_ids = concat(
#         module.vpc.private_route_table_ids,
#         module.vpc.public_route_table_ids
#       )
#       tags = merge(local.tags, {
#         Name = "${local.name}-ssh-gateway-endpoint"
#       })
#     },

#     # Interface Endpoint (ECR API)
#     ecr_api = {
#       service             = "ecr.api"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc.private_subnets
#       tags = merge(local.tags, {
#         Name = "${local.name}-ecr-api-interface"
#       })
#     }
#   }

#   tags = merge(local.tags, {
#     Name = "${local.name}-vpc-endpoint"
#   })
# }
