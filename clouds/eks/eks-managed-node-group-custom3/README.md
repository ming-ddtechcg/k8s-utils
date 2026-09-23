# EKS Managed Node Group via terraform - Custom 3

** Custom: begin **
This custom is based on Custom 2 infrastructure.

Changes are:
1. added the module EC2 for creating a bastion host
2. added the security group to allow the SSH traffic from the internet
** Custom: end **

There are few configurations that are required to be updated (i.e. region, azs, and more) based on the account setup in variables.tf.

In eks.tf, this example is to use the multi node groups for the different instance types with the custom EBS setup.

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
