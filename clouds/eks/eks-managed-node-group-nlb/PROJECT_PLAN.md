# Project Plan - EKS Managed Node Group with Network Load Balancer

## 1. Network Load Balancer + Target Groups (`nlb.tf`)

- **Target Groups** - one per listener port (`80`, `443`), `target_type = "instance"`,
  protocol `TCP`, created in the same VPC as the EKS cluster.
- **Auto Scaling Group attachment** - every Auto Scaling Group from the `eks` module's
  `eks_managed_node_groups` (`linux-small-nodes`, `linux-medium-nodes`) is attached to
  both target groups via `aws_autoscaling_attachment`.
- **Network Load Balancer**:
  - public facing (`internal = false`)
  - spans all public subnets, one per availability zone, with cross-zone load
    balancing enabled so traffic is routed across all AZs
  - associated with the `eks` module's node security group
    (`module.eks.node_security_group_id`), which allows public inbound `80`/`443`
    via `node_security_group_additional_rules` in `eks.tf`
- **Listeners** - `TCP/80` forwards to the http target group, `TCP/443` forwards to
  the https target group.
- **Output** - `nlb_dns_name` exposes the load balancer's public DNS name.

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
