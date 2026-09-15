# EKS Managed Node Group via terraform

There are few configurations that are required to be updated (i.e. region, az, and more) based on the account setup in main.tf.

In eks.tf, the cluster information is required to be updated as well due to the Kubernetes configurations in AWS.  In addition, this example is to use the multi node groups for the different instance types.

To deploy the configurations with the following steps:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

After the cluster creation is completed, the kubernetes configuration can be retrieved with following step:

```bash
aws eks update-kubeconfig \
    --name test-cluster \
    --region us-east-2
```

output:

```
$ kubectl get nodes
NAME                                       STATUS   ROLES    AGE     VERSION
ip-10-0-14-26.us-east-2.compute.internal   Ready    <none>   8m32s   v1.36.3-eks-cb19647
ip-10-0-18-78.us-east-2.compute.internal   Ready    <none>   8m30s   v1.36.3-eks-cb19647
ip-10-0-8-201.us-east-2.compute.internal   Ready    <none>   8m46s   v1.36.3-eks-cb19647
```

To destroy the cluster:

```bash
terraform destroy
```

## Makefile support

The Makefile file is generated from the claude code to simply the terraform flow.  It's document is at:

[claude-v1.txt](./docs/claude-v1.txt)

