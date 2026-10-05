# Classic Load Balancer for the EKS managed node groups
# Fronts the node group instances on ports 80/443 (see
# node_security_group_additional_rules in eks.tf), e.g. for an ingress
# controller running with hostNetwork on the nodes.
#
# A Classic Load Balancer (aws_elb) has no target group concept -- unlike
# ALB/NLB, it registers EC2 instances directly, so there's one listener per
# port on the ELB itself and one autoscaling attachment per node group.

locals {
  clb_listeners = {
    http = {
      port = 80
    }
    https = {
      port = 443
    }
  }
}

# Public-facing Classic Load Balancer spanning all public subnets (one per
# AZ), associated with the eks module's node security group (which allows
# 80/443 inbound).
resource "aws_elb" "this" {
  name     = "${var.deployment_name}-clb"
  internal = false

  subnets         = module.vpc.public_subnets
  security_groups = [module.eks.node_security_group_id]

  cross_zone_load_balancing = true

  dynamic "listener" {
    for_each = local.clb_listeners
    content {
      lb_port           = listener.value.port
      lb_protocol       = "TCP"
      instance_port     = listener.value.port
      instance_protocol = "TCP"
    }
  }

  health_check {
    target              = "TCP:${local.clb_listeners.http.port}"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = local.tags
}

# Attach every Auto Scaling Group from the eks_managed_node_groups directly
# to the Classic Load Balancer (one attachment per node group -- Classic ELB
# has no per-port target groups to fan out across).
resource "aws_autoscaling_attachment" "this" {
  for_each = module.eks.eks_managed_node_groups

  autoscaling_group_name = each.value.node_group_autoscaling_group_names[0]
  elb                    = aws_elb.this.name
}
