all: check README.md

.PHONY: check
check:
	terraform fmt -check=true -diff=true
	AWS_REGION=eu-west-1 terraform validate

README.md: variables.tf outputs.tf
	sed -e '/^<!--terraform-docs-->/q' $@ > $@.tmp
	terraform-docs md . >> $@.tmp
	mv $@.tmp $@
