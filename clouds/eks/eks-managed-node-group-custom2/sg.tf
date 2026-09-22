resource "aws_security_group" "node_ssh" {
  name_prefix = "${var.deployment_name}-node-ssh-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from bastion/CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # scope this down to your actual source
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

