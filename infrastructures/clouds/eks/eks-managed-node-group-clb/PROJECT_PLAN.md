# Project Plan - EKS Managed Node Group with Classic Load Balancer

Based on the hand-written plan ([claude_plan_v1.txt](./docs/claude_plan_v1.txt)) and the
existing Terraform sources, this project adds a public-facing Classic Load Balancer (CLB)
in front of the EKS managed node groups, in a separate file (`clb.tf`).

> **Change from plan v1:** v1 asked for a Target Group (TG) attached to the Auto Scaling
> Groups (ASGs), with the CLB attached to that TG. A Classic Load Balancer (`aws_elb`)
> has no target group concept -- only ALB/NLB do. The CLB registers instances directly,
> so the TG is dropped and the ASGs are attached to the CLB itself.

## 1. Classic Load Balancer (`clb.tf`)

- **Public facing** - `aws_elb.this` with `internal = false`.
- **All availability zones** - spans `module.vpc.public_subnets` (one per AZ) with
  `cross_zone_load_balancing = true`.
- **Security group** - associated with the `eks` module's node security group
  (`module.eks.node_security_group_id`), which allows public inbound `80`/`443` from
  `0.0.0.0/0` via `node_security_group_additional_rules` in `eks.tf`.
- **Listeners** - `80` and `443`, TCP passthrough to the same instance port (no TLS
  termination or certificate on the CLB).
- **Health check** - TCP against instance port `80` (interval 10s, timeout 5s,
  healthy/unhealthy threshold 3).

## 2. Auto Scaling Group attachment (`clb.tf`)

Every ASG from the `eks` module's `eks_managed_node_groups` (`linux-small-nodes`,
`linux-medium-nodes`) is registered with the CLB via `aws_autoscaling_attachment` -- one
attachment per node group, using `node_group_autoscaling_group_names[0]`.

## 3. Output (`outputs.tf`)

`clb_dns_name` exposes the load balancer's public DNS name.

## 4. Notes

- Instances report `OutOfService` on the CLB health check until something listens on
  port `80` on the nodes (e.g. an ingress controller deployed with `hostNetwork`).
- The configuration passes `terraform validate`; it has not been planned or applied.
- Related documents: [claude_plan_v2.txt](./docs/claude_plan_v2.txt) - final CLB
  implementation plan.
