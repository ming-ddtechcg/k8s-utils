# Project Plan - EKS Managed Node Group

## 1. Makefile: Terraform lifecycle targets

- `init` - run `terraform init` if the working directory has not been initialized yet.
- `plan` - run `terraform plan` on first build, or whenever any `.tf` file has changed.
- `apply` - run `terraform apply`, only if `terraform plan` completed without error.
- `destroy` - run `terraform destroy`, only if a `terraform plan` has been made and AWS
  resources have actually been deployed.

## 2. Makefile: cleanup target

1. Run `terraform destroy` first, if a `terraform plan` has been made and AWS resources
   have been deployed, to tear down all deployed resources.
2. Remove the `.terraform` directory.
3. Remove the files `.terraform.lock.hcl`, `terraform.tfstate`, and
   `terraform.tfstate.backup`.
