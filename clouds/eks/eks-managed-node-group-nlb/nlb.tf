# Network Load Balancer + Target Groups for the EKS managed node groups
# Fronts the node group instances on ports 80/443 (see
# node_security_group_additional_rules in eks.tf), e.g. for an ingress
# controller running with hostNetwork on the nodes.

locals {
  nlb_listeners = {
    http = {
      port     = 80
      protocol = "TCP"
    }
    https = {
      port     = 443
      protocol = "TCP"
    }
  }
}

# One target group per listener port, targeting the node instances directly.
resource "aws_lb_target_group" "this" {
  for_each = local.nlb_listeners

  name        = "${local.name}-${each.key}-tg"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

  tags = local.tags
}

# Attach every Auto Scaling Group from the eks_managed_node_groups to every
# target group above.
#
# The for_each key set is built from the node group *keys* (statically known
# from eks_managed_node_groups in eks.tf), not from the ASG names themselves
# -- the actual ASG names aren't known until after the node groups are
# created, and for_each keys must be known at plan time.
resource "aws_autoscaling_attachment" "this" {
  for_each = {
    for pair in setproduct(keys(local.nlb_listeners), keys(module.eks.eks_managed_node_groups)) :
    "${pair[0]}-${pair[1]}" => {
      listener_key   = pair[0]
      node_group_key = pair[1]
    }
  }

  autoscaling_group_name = module.eks.eks_managed_node_groups[each.value.node_group_key].node_group_autoscaling_group_names[0]
  lb_target_group_arn    = aws_lb_target_group.this[each.value.listener_key].arn
}

# Public-facing NLB spanning all public subnets (one per AZ), associated
# with the eks module's node security group (which allows 80/443 inbound).
resource "aws_lb" "this" {
  name               = "${local.name}-nlb"
  load_balancer_type = "network"
  internal           = false

  subnets         = module.vpc.public_subnets
  security_groups = [module.eks.node_security_group_id]

  enable_cross_zone_load_balancing = true

  tags = local.tags
}

resource "aws_lb_listener" "this" {
  for_each = local.nlb_listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}
