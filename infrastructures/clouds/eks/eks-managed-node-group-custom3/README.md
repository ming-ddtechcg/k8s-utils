# EKS Managed Node Group via terraform - Custom 3

** Custom: begin **
This custom is based on Custom 2 infrastructure.

Changes are:
1. add the module EC2 for creating a bastion host
2. add the security group to allow the SSH traffic from the internet
3. stop the bastion host initially
** Custom: end **

There are few configurations that are required to be updated (i.e. region, azs, and more) based on the account setup in variables.tf.

In eks.tf, this example is to use the multi node groups for the different instance types with the custom EBS setup.

## create a cluster

To deploy the configurations with the following steps:

```bash
$ terraform init
```

```bash
$ terraform plan
$ terraform apply --auto-approve
```

or

```bash
$ terraform plan -var "deployment_name=<deployment_name>"
$ terraform apply -var "deployment_name=<deployment_name>" --auto-approve
```

## destroy all created resources

```bash
$ terraform destroy --auto-approve
```

or

```bash
$ terraform destroy -var "deployment_name=<deployment_name>" --auto-approve
```

