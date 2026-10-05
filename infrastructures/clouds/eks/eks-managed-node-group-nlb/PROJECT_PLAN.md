# Project Plan - EKS Managed Node Group with Network Load Balancer

Built on the existing EKS managed node group Terraform code, this project adds a public
Network Load Balancer (NLB) and Target Groups (TG) in a separate Terraform file, `nlb.tf`.

## 1. Target Groups (`nlb.tf`)

- One Target Group per listener port (`80` and `443`), named `<name>-http-tg` and
  `<name>-https-tg`, with `target_type = "instance"` and protocol `TCP`, created in the
  same VPC as the EKS cluster.
- Health check: `TCP` on the traffic port (3 healthy / 3 unhealthy thresholds, 10s interval).
- **Auto Scaling Group attachment** - every Auto Scaling Group (ASG) created by the
  `eks` module in `eks_managed_node_groups` (`linux-small-nodes`, `linux-medium-nodes`)
  is attached to both Target Groups via `aws_autoscaling_attachment`. The attachments
  are keyed on the node group keys, which are known at plan time, rather than on the ASG
  names, which are only known after the node groups are created.

## 2. Network Load Balancer (`nlb.tf`)

- **Public facing** (`internal = false`).
- **Routes to all availability zones** - spans all public subnets (one per AZ) with
  cross-zone load balancing enabled.
- **Security group** - associated with the security group created by the `eks` module
  (`module.eks.node_security_group_id`), which has the rules for the public inbound ports
  `80` and `443` (`node_security_group_additional_rules` in `eks.tf`).
- **Listeners** - `TCP/80` forwards to the http Target Group, and `TCP/443` forwards to
  the https Target Group.
- **Output** - `nlb_dns_name` (in `outputs.tf`) exposes the public DNS name of the NLB.

## 3. File layout

| File           | Content                                                                 |
| -------------- | ----------------------------------------------------------------------- |
| `provider.tf`  | AWS provider configuration                                              |
| `versions.tf`  | Terraform and provider version constraints                              |
| `main.tf`      | shared `locals` (name, region, AZs, VPC CIDR, tags)                     |
| `vpc.tf`       | VPC module (public, private and intra subnets, NAT gateways)            |
| `eks.tf`       | EKS cluster, add-ons, managed node groups, and the 80/443 node SG rules |
| `nlb.tf`       | Target Groups, ASG attachments, NLB and listeners                       |
| `outputs.tf`   | kubeconfig command and `nlb_dns_name`                                   |

## 4. Note

The Target Group health checks report unhealthy until a workload listens on ports `80`
and `443` on the nodes, e.g. an ingress controller deployed with `hostNetwork`.
