# Project Plan - EKS Managed Node Group

## 1. Makefile: Terraform lifecycle targets

- `init` - runs `terraform init`, but only if the `.terraform/` directory doesn't
  already exist.
- `plan` - runs `init` first if not yet initialized, then runs
  `terraform plan -out=tfplan`. Automatically re-plans whenever any `.tf` file has
  changed since the last plan (compared by file timestamp against `tfplan`);
  otherwise reuses the existing `tfplan`. Removes `tfplan` if the plan fails.
- `apply` - ensures a fresh `tfplan` exists first (running `plan` if one isn't
  already up to date), then runs `terraform apply tfplan`. Deletes `tfplan`
  afterwards since state has changed and any prior plan is now stale.
- `destroy` - runs `init` first if needed, then stops with a clear error if no
  `terraform.tfstate` exists or if `terraform state list` shows no deployed
  resources; otherwise runs `terraform destroy` (prompts for confirmation) and
  clears any stale `tfplan`.

## 2. Makefile: cleanup target (`clean`)

1. Runs `destroy` first, but only if `.terraform/` exists, `terraform.tfstate`
   exists, and `terraform state list` shows deployed resources.
2. Removes `.terraform/`, `.terraform.lock.hcl`, `terraform.tfstate`,
   `terraform.tfstate.backup`, and `tfplan`.
