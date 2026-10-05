# EKS Managed Node Group via terraform - Custom 2

** Custom: begin **
eks_managed_node_groups contains the following changes:
1. EBS root size
2. key name for the SSH remote connection
3. SG for allowing the SSH inbound traffic
** Custom: end **

There are few configurations that are required to be updated (i.e. region, azs, and more) based on the account setup in variables.tf.

In eks.tf, this example is to use the multi node groups for the different instance types with the custom EBS setup.

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
