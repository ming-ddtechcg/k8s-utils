# EKS Managed Node Group via terraform

There are few configurations that are required to be updated (i.e. region, az, and more) based on the account setup in main.tf.

In eks.tf, the cluster information is required to be updated as well due to the Kubernetes configurations in AWS.  In addition, this example is to use the multi node groups for the different instance types.

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
