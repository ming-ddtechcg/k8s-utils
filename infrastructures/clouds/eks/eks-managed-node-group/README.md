# EKS Managed Node Group via terraform

There are few configurations that are required to be updated (i.e. region, az, and more) based on the account setup in variables.tf.

In eks.tf, this example is to use the multi node groups for the different instance types.

To deploy the configurations with the following steps:


## create a cluster 

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

## destroy the cluster:

```bash
terraform destroy
```

or

```bash
terraform destroy -var "deployment_name=<deployment_name>" --auto-approve
```

