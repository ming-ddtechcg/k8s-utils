# EKS Managed Node Group with Classic Load Balancer via terraform

There are few configurations that are required to be updated (i.e. region, az, and more) based on the account setup in variables.tf.

In eks.tf, this example is to use the multi node groups for the different instance types.

## create a cluster

To deploy the configurations with the following steps:

```bash
$ terraform init
```

```bash
$ terraform plan
$ terraform apply --auto-approve
```

```bash
$ terraform plan -var "deployment_name=<deployment_name>"
$ terraform apply -var "deployment_name=<deployment_name>" --auto-approve
```

## destroy the cluster:

```bash
terraform destroy
```

or

```bash
terraform destroy -var "deployment_name=<deployment_name>" --auto-approve
```

## claude code support

This project also adds a public-facing Classic Load Balancer (`clb.tf`) in front of the managed node group instances on ports 80/443. Its documents are at:

- [claude_plan_v1.txt](./docs/claude_plan_v1.txt) - original hand-written plan
- [claude_plan_v2.txt](./docs/claude_plan_v2.txt) - final CLB implementation plan
- [PROJECT_PLAN.md](./PROJECT_PLAN.md) - final CLB implementation project plan

