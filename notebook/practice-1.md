# EXPERIMENT TERRAFORM

![Avatar](img/ghislain.webp "Ghislain Bernard") [![Gmail](img/gmail.webp "ghislain.bernard@gmail.com")](mailto:ghislain.bernard@gmail.com) [![Github](img/github.webp "ghislain-bernard")](https://github.com/ghislain-bernard) [![LinkedIN](img/linkedin.webp "ghislain-bernard")](https://www.linkedin.com/in/ghislain-bernard)

`c[_] 2025`

## PRACTICE #1 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform) [![Debian](img/debian.webp "Debian")](https://debian.org)

REF: https://www.youtube.com/watch?v=7gtzumVHZtE

```bash
$ cat >main.tf <<EOF
output "variable" {
  value = "template"
}
EOF

$ ls --almost-all --width=1
main.tf

$ terraform init
Initializing the backend...
Initializing provider plugins...

Terraform has been successfully initialized!
...

$ terraform validate
Success! The configuration is valid.

```

```bash
$ terraform plan --out=tfplan

Changes to Outputs:
  + variable = "template"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform show tfplan

Changes to Outputs:
  + variable = "template"

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
        "value": "template"
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
      "after": "template",
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
          "value": "template",
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
            "constant_value": "template"
          }
        }
      }
    }
  },
  "timestamp": "2025-09-02T15:38:43Z",
  "applyable": true,
  "complete": true,
  "errored": false
}

$ file --brief tfplan
Zip archive data, made by v2.0, extract using at least v2.0, last modified Sep 02 2025 15:38:42, uncompressed size 123,
 method=deflate

$ unzip -l tfplan
Archive:  tfplan
  Length      Date    Time    Name
---------  ---------- -----   ----
      123  2025-09-02 15:38   tfplan
      222  2025-09-02 15:38   tfstate
      145  2025-09-02 15:38   tfstate-prev
       43  2025-09-02 15:38   tfconfig/m-/main.tf
       41  2025-09-02 15:38   tfconfig/modules.json
      107  2025-09-02 15:38   .terraform.lock.hcl
---------                     -------
      681                     6 files

$ unzip -p tfplan .terraform.lock.hcl
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

$ unzip -p tfplan tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 0,
  "lineage": "",
  "outputs": {
    "variable": {
      "value": "template",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}

$ unzip -p tfplan tfconfig/m-/main.tf
output "variable" {
  value = "template"
}

$ unzip -p tfplan tfconfig/modules.json
[
  {
    "Key": "",
    "Dir": "."
  }

```

```bash
$ terraform apply tfplan

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "template"

$ ls --almost-all --width=1
main.tf
terraform.tfstate
tfplan

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "1095bea3-744b-40a5-8436-d27e8626d2d2",
  "outputs": {
    "variable": {
      "value": "template",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}

```

```bash
$ terraform destroy -auto-approve

Changes to Outputs:
  - variable = "template" -> null

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Destroy complete! Resources: 0 destroyed.

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 2,
  "lineage": "1095bea3-744b-40a5-8436-d27e8626d2d2",
  "outputs": {},
  "resources": [],
  "check_results": null
}

$ ls --almost-all --width=1
main.tf
terraform.tfstate
terraform.tfstate.backup
tfplan

$ rm --verbose main.tf terraform.tfstate terraform.tfstate.backup tfplan
removed 'main.tf'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'
removed 'tfplan'

```

&nbsp;  
`-`

> MIT License  
> ghislain.bernard@gmail.com

![Monster](img/monster.webp "Boo!")
