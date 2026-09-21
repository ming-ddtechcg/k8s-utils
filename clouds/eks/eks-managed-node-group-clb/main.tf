data "aws_availability_zones" "available" {
}

locals {
  name   = "test"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-2a", "us-east-2b"]

  tags = {
    Name       = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

