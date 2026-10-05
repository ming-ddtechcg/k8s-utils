
data "aws_vpc" "default_vpc" {
  tags = {
    Env = "default"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  tags = {
    Type = "private"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  tags = {
    Type = "public"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  name = "test"

  region             = "us-east-2"
  vpc_id             = data.aws_vpc.default_vpc.id
  vpc_cidr           = data.aws_vpc.default_vpc.cidr_block
  azs                = [data.aws_availability_zones.available.id]
  subnet_private_ids = [for s in data.aws_subnet.private : s.id]
  subnet_public_ids  = [for s in data.aws_subnet.public : s.id]

  tags = {
    Name       = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}
