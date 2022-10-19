#!/bin/bash

terraform fmt

terraform workspace select production-eu-west-1
echo "You are using TF Workspace `terraform workspace list | grep \*`"
terraform plan --var-file=production-eu-west-1.tfvars -out=production-eu-west-1.tfplan