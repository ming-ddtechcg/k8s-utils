# Project Plan - EKS Managed Node Group with Classic Load Balancer

## 1. Classic Load Balancer (`clb.tf`)

Classic Load Balancer (`aws_elb`) has no target group concept -- unlike ALB/NLB, it
registers EC2 instances directly against the load balancer itself.

- **Classic Load Balancer**:
  - public facing (`internal = false`)
  - spans all public subnets, one per availability zone, with cross-zone load
    balancing enabled so traffic is routed across all AZs
  - associated with the `eks` module's node security group
    (`module.eks.node_security_group_id`), which allows public inbound `80`/`443`
    via `node_security_group_additional_rules` in `eks.tf`
  - listeners on `80` and `443`, forwarding TCP passthrough to the same instance
    port
  - TCP health check against instance port `80`
- **Auto Scaling Group attachment** - every Auto Scaling Group from the `eks` module's
  `eks_managed_node_groups` (`linux-small-nodes`, `linux-medium-nodes`) is registered
  directly with the CLB via `aws_autoscaling_attachment` (one attachment per node
  group, since Classic ELB has no per-port target groups to fan out across).
- **Output** - `clb_dns_name` exposes the load balancer's public DNS name.

## 2. Makefile: Terraform lifecycle targets

- `make init` - like `terraform init`, run only if the working directory has not been
  initialized yet.
- `make plan` - like `terraform plan`, to preview infrastructure creation or updates;
  runs `make init` first if that has not been done yet.
- `make apply` - runs `make plan` first if that has not been done yet, then performs
  `terraform apply`.
- `make destroy` - like `terraform destroy`, to remove all deployed AWS resources, run
  only if AWS resources have actually been deployed.

## 3. Makefile: cleanup target

1. Perform `make destroy`.
2. Clean up the local directories and files created by Terraform: the `.terraform/`
   directory, `.terraform.lock.hcl`, `terraform.tfstate`, `terraform.tfstate.backup`,
   and the Makefile's own leftover plan file.
