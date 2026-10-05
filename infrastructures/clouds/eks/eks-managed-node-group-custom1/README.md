# EKS Managed Node Group via terraform - Custom 1

** Custom: begin **
This version is to use the existing VPC data resources for setting up EKS.

eks_managed_node_groups contains the following changes:
1. EBS root size
2. key name for the SSH remote connection
3. SG for allowing the SSH inbound traffic
** Custom: end **

In eks.tf, the cluster information is required to be updated as well due to the Kubernetes configurations in AWS.  In addition, this example is to use the multi node groups for the different instance types.

For some reasons, the EKS build does not work in the priavte subnets (it is required the addition investigation).

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
