# EKS Managed Node Group via terraform - Custom 2

** Custom: begin **
eks_managed_node_groups contains the following changes:
1. EBS root size
2. key name for the SSH remote connection
3. SG for allowing the SSH inbound traffic
** Custom: end **

There are few configurations that are required to be updated (i.e. region, azs, and more) based on the account setup in main.tf.

In eks.tf, the cluster information is required to be updated as well due to the Kubernetes configurations in AWS.  In addition, this example is to use the multi node groups for the different instance types.

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
