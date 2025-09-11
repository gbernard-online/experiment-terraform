# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/language/values/outputs  
https://developer.hashicorp.com/terraform/cli/commands/fmt  
https://developer.hashicorp.com/terraform/cli/commands/init  
https://developer.hashicorp.com/terraform/cli/commands/validate  
https://developer.hashicorp.com/terraform/cli/commands/plan  
https://developer.hashicorp.com/terraform/cli/commands/show  
https://developer.hashicorp.com/terraform/cli/commands/apply  
https://developer.hashicorp.com/terraform/cli/commands/destroy

https://www.youtube.com/watch?v=7gtzumVHZtE&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #1 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13

```bash
$ cat >main.tf <<EOF
output "variable" {
  value = "value"
}
EOF

$ terraform fmt --check --diff

$ terraform init
Initializing the backend...
Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan --out=tfplan

Changes to Outputs:
  + variable = "value"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ ls --almost-all --width=1
main.tf
tfplan

$ terraform show tfplan

Changes to Outputs:
  + variable = "value"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

$ terraform show --json tfplan | jq
{
  "format_version": "1.2",
  "terraform_version": "1.13.1",
  "planned_values": {
    "outputs": {
      "variable": {
        "sensitive": false,
        "type": "string",
        "value": "value"
      }
    },
    "root_module": {}
  },
  "output_changes": {
    "variable": {
      "actions": [
        "create"
      ],
      "before": null,
      "after": "value",
      "after_unknown": false,
      "before_sensitive": false,
      "after_sensitive": false
    }
  },
  "prior_state": {
    "format_version": "1.0",
    "terraform_version": "1.13.1",
    "values": {
      "outputs": {
        "variable": {
          "sensitive": false,
          "value": "value",
          "type": "string"
        }
      },
      "root_module": {}
    }
  },
  "configuration": {
    "root_module": {
      "outputs": {
        "variable": {
          "expression": {
            "constant_value": "value"
          }
        }
      }
    }
  },
  "timestamp": "2025-09-03T16:28:18Z",
  "applyable": true,
  "complete": true,
  "errored": false
}

$ file --brief tfplan
Zip archive data, made by v2.0, extract using at least v2.0, last modified Sep 03 2025 08:51:28, uncompressed si
ze 120, method=deflate

$ unzip -l tfplan
Archive:  tfplan
  Length      Date    Time    Name
---------  ---------- -----   ----
      120  2025-09-03 16:28   tfplan
      219  2025-09-03 16:28   tfstate
      145  2025-09-03 16:28   tfstate-prev
       40  2025-09-03 16:28   tfconfig/m-/main.tf
       41  2025-09-03 16:28   tfconfig/modules.json
      107  2025-09-03 16:28   .terraform.lock.hcl
---------                     -------
      672                     6 files

$ unzip -p tfplan tfconfig/m-/main.tf
output "variable" {
  value = "value"
}

$ unzip -p tfplan .terraform.lock.hcl
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

$ unzip -p tfplan tfconfig/modules.json && echo
[
  {
    "Key": "",
    "Dir": "."
  }
]

$ unzip -p tfplan tfstate-prev
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 0,
  "lineage": "",
  "outputs": {},
  "resources": [],
  "check_results": null
}

$ unzip -p tfplan tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 0,
  "lineage": "",
  "outputs": {
    "variable": {
      "value": "value",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}

$ diff <(unzip -p tfplan tfstate-prev) <(unzip -p tfplan tfstate)
6c6,11
<   "outputs": {},
---
>   "outputs": {
>     "variable": {
>       "value": "value",
>       "type": "string"
>     }
>   },
```

```bash
$ terraform apply tfplan

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "value"

$ ls --almost-all --width=1
main.tf
terraform.tfstate
tfplan

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",
  "outputs": {
    "variable": {
      "value": "value",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}

$ diff <(unzip -p tfplan tfstate) terraform.tfstate
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",
```

```bash
$ terraform destroy -auto-approve

Changes to Outputs:
  - variable = "value" -> null

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Destroy complete! Resources: 0 destroyed.

$ ls --almost-all --width=1
main.tf
terraform.tfstate
terraform.tfstate.backup
tfplan

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 2,
  "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",
  "outputs": {},
  "resources": [],
  "check_results": null
}

$ cat terraform.tfstate.backup
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",
  "outputs": {
    "variable": {
      "value": "value",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}

$ diff <(unzip -p tfplan tfstate-prev) terraform.tfstate
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 2,
>   "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",

$ diff <(unzip -p tfplan tfstate) terraform.tfstate.backup
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "ec5c74ce-8dbe-b9f5-0b4b-4353e12226cd",

$ rm --verbose main.tf terraform.tfstate terraform.tfstate.backup tfplan
removed 'main.tf'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'
removed 'tfplan'
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
