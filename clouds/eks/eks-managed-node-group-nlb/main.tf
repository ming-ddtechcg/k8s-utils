data "aws_availability_zones" "available" {
}

locals {
  name   = var.deployment_name
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-2a", "us-east-2b"]

  tags = {
    Deployment = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}
