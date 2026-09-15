TF_FILES := $(wildcard *.tf)
PLAN_FILE := tfplan

.PHONY: all init plan apply destroy clean

all: apply

# Only runs terraform init if the .terraform directory doesn't exist yet.
.terraform:
	terraform init

init: .terraform

# Re-plans when it's the first run (no plan file yet) or any .tf file changed
# since the last successful plan. Relies on make's mtime comparison against
# $(PLAN_FILE), so an unchanged plan is reused instead of re-running.
$(PLAN_FILE): $(TF_FILES) | .terraform
	@terraform plan -out=$@ -detailed-exitcode; \
	ec=$$?; \
	if [ $$ec -eq 1 ]; then \
		rm -f $@; \
		exit 1; \
	fi

plan: $(PLAN_FILE)

# Applies only the plan produced by the plan step above, i.e. only if
# terraform plan succeeded. Removes the plan file afterwards since state
# has changed and any prior plan is now stale.
apply: $(PLAN_FILE)
	terraform apply "$(PLAN_FILE)"
	@rm -f $(PLAN_FILE)

# Only destroys if init has happened and the state file shows resources are
# actually deployed. Prompts for confirmation via terraform's own destroy
# prompt; any stale plan file is dropped afterwards since state has changed.
destroy: .terraform
	@if [ ! -f terraform.tfstate ]; then \
		echo "No terraform.tfstate found - run 'make apply' first."; \
		exit 1; \
	fi; \
	if [ -z "$$(terraform state list)" ]; then \
		echo "No resources found in state - nothing to destroy."; \
		exit 1; \
	fi
	terraform destroy
	@rm -f $(PLAN_FILE)

# Destroys any deployed AWS resources first (stopping here if that fails or
# is declined), then removes the local terraform state/init artifacts.
clean:
	@if [ -f terraform.tfstate ] && [ -d .terraform ] && [ -n "$$(terraform state list 2>/dev/null)" ]; then \
		$(MAKE) destroy; \
	fi
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup $(PLAN_FILE)
