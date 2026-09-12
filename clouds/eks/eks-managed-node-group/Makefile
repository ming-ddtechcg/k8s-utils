TF_FILES := $(wildcard *.tf)
PLAN_FILE := tfplan

.PHONY: all init plan apply clean

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

clean:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup $(PLAN_FILE)
