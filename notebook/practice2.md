# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/language/block/variable  
https://developer.hashicorp.com/terraform/language/expressions/strings  
https://spacelift.io/blog/how-to-use-terraform-variables  
https://developer.hashicorp.com/terraform/language/block/resource  
https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource  
https://developer.hashicorp.com/terraform/language/provisioners

https://www.youtube.com/watch?v=LmHKEiZ1SeA&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #2 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13

```bash
$ cat >main.tf <<EOF
variable "color" {
  type    = string
  default = "green"
}

resource "null_resource" "color" {
  triggers = {
    color = var.color
  }
  provisioner "local-exec" {
    command = "echo '\${var.color}' | tee color.txt"
  }
}

output "color" {
  value = var.color
}
EOF

$ terraform fmt --check --diff

$ terraform validate
╷
│ Error: Missing required provider
│
│ This configuration requires provider registry.terraform.io/hashicorp/null, but that provider isnʼt available.
│ You may be able to install it automatically by running:
│   terraform init
╵

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Installing hashicorp/null v3.2.4...
- Installed hashicorp/null v3.2.4 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

$ terraform validate
Success! The configuration is valid.

$ ls --almost-all --width=1
.terraform
main.tf
.terraform.lock.hcl

$ find -type f | as-tree
.terraform/providers/registry.terraform.io/hashicorp/null/3.2.4/linux_amd64
├── LICENSE.txt
└── terraform-provider-null_v3.2.4_x5

7 directories, 2 files

$ cat .terraform.lock.hcl
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/null" {
  version = "3.2.4"
  hashes = [
    "h1:hkf5w5B6q8e2A42ND2CjAvgvSN3puAosDmOJb3zCVQM=",
    "zh:59f6b52ab4ff35739647f9509ee6d93d7c032985d9f8c6237d1f8a59471bbbe2",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:795c897119ff082133150121d39ff26cb5f89a730a2c8c26f3a9c1abf81a9c43",
    "zh:7b9c7b16f118fbc2b05a983817b8ce2f86df125857966ad356353baf4bff5c0a",
    "zh:85e33ab43e0e1726e5f97a874b8e24820b6565ff8076523cc2922ba671492991",
    "zh:9d32ac3619cfc93eb3c4f423492a8e0f79db05fec58e449dee9b2d5873d5f69f",
    "zh:9e15c3c9dd8e0d1e3731841d44c34571b6c97f5b95e8296a45318b94e5287a6e",
    "zh:b4c2ab35d1b7696c30b64bf2c0f3a62329107bd1a9121ce70683dec58af19615",
    "zh:c43723e8cc65bcdf5e0c92581dcbbdcbdcf18b8d2037406a5f2033b1e22de442",
    "zh:ceb5495d9c31bfb299d246ab333f08c7fb0d67a4f82681fbf47f2a21c3e11ab5",
    "zh:e171026b3659305c558d9804062762d168f50ba02b88b231d20ec99578a6233f",
    "zh:ed0fe2acdb61330b01841fa790be00ec6beaac91d41f311fb8254f74eb6a711f",
  ]
}

$ md5sum .terraform.lock.hcl
cbe9bade7f8e1cf9ac849e29fb1c65d7  .terraform.lock.hcl
```

```bash
$ terraform plan --out=tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.color will be created
  + resource "null_resource" "color" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "green"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + color = "green"

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ ls --almost-all --width=1
.terraform
main.tf
.terraform.lock.hcl
tfplan

$ unzip -l tfplan
Archive:  tfplan
  Length      Date    Time    Name
---------  ---------- -----   ----
      227  2025-09-03 21:53   tfplan
      216  2025-09-03 21:53   tfstate
      145  2025-09-03 21:53   tfstate-prev
      264  2025-09-03 21:53   tfconfig/m-/main.tf
       41  2025-09-03 21:53   tfconfig/modules.json
     1152  2025-09-03 21:53   .terraform.lock.hcl
---------                     -------
     2045                     6 files

$ unzip -p tfplan .terraform.lock.hcl | md5sum
cbe9bade7f8e1cf9ac849e29fb1c65d7  -

$ unzip -p tfplan tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 0,
  "lineage": "",
  "outputs": {
    "color": {
      "value": "green",
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
>     "color": {
>       "value": "green",
>       "type": "string"
>     }
>   },
```

```bash
$ terraform apply tfplan
null_resource.color: Creating...
null_resource.color: Provisioning with 'local-exec'...
null_resource.color (local-exec): Executing: ["/bin/sh" "-c" "echo 'green' | tee color.txt"]
null_resource.color (local-exec): green
null_resource.color: Creation complete after 0s [id=3056772015431020915]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

color = "green"

$ terraform output
color = "green"

$ ls --almost-all --width=1
.terraform
color.txt
main.tf
.terraform.lock.hcl
terraform.tfstate
tfplan

$ cat color.txt
green

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "5120676a-b28b-3935-e18c-a06b83506651",
  "outputs": {
    "color": {
      "value": "green",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "color",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "3056772015431020915",
            "triggers": {
              "color": "green"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        }
      ]
    }
  ],
  "check_results": null
}

$ md5sum terraform.tfstate
a4fb328733938456021384cee2eee7b2  terraform.tfstate

$ diff <(unzip -p tfplan tfstate) terraform.tfstate
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "5120676a-b28b-3935-e18c-a06b83506651",
12c12,32
<   "resources": [],
---
>   "resources": [
>     {
>       "mode": "managed",
>       "type": "null_resource",
>       "name": "color",
>       "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
>       "instances": [
>         {
>           "schema_version": 0,
>           "attributes": {
>             "id": "3056772015431020915",
>             "triggers": {
>               "color": "green"
>             }
>           },
>           "sensitive_attributes": [],
>           "identity_schema_version": 0
>         }
>       ]
>     }
>   ],
```

```bash
$ terraform apply tfplan
╷
│ Error: Saved plan is stale
│
│ The given plan file can no longer be applied because the state was changed by another operation after the
│ plan was created.
╵

$ terraform plan --out=tfplan
null_resource.color: Refreshing state... [id=3056772015431020915]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no
changes are needed.

$ unzip -l tfplan
Archive:  tfplan
  Length      Date    Time    Name
---------  ---------- -----   ----
      237  2025-09-03 22:01   tfplan
      726  2025-09-03 22:01   tfstate
      690  2025-09-03 22:01   tfstate-prev
      264  2025-09-03 22:01   tfconfig/m-/main.tf
       41  2025-09-03 22:01   tfconfig/modules.json
     1152  2025-09-03 22:01   .terraform.lock.hcl
---------                     -------
     3110                     6 files

$ unzip -p tfplan tfstate | md5sum
a4fb328733938456021384cee2eee7b2  -

$ terraform apply tfplan

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

color = "green"

$ md5sum terraform.tfstate
a4fb328733938456021384cee2eee7b2  terraform.tfstate
```

```bash
$ patch --forward --reject-file=- main.tf <<EOF
3c3
<   default = "green"
---
>   default = "red"
EOF
patching file main.tf

$ cat main.tf | head --lines=4
variable "color" {
  type    = string
  default = "red"
}

$ terraform fmt --check --diff

$ terraform validate
Success! The configuration is valid.

$ terraform plan --out=tfplan
null_resource.color: Refreshing state... [id=3056772015431020915]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.color must be replaced
-/+ resource "null_resource" "color" {
      ~ id       = "3056772015431020915" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "color" = "green" -> "red"
        }
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ color = "green" -> "red"

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ unzip -l tfplan
Archive:  tfplan
  Length      Date    Time    Name
---------  ---------- -----   ----
      311  2025-09-03 22:31   tfplan
      724  2025-09-03 22:31   tfstate
      690  2025-09-03 22:31   tfstate-prev
      262  2025-09-03 22:31   tfconfig/m-/main.tf
       41  2025-09-03 22:31   tfconfig/modules.json
     1152  2025-09-03 22:31   .terraform.lock.hcl
---------                     -------
     3180                     6 files

$ diff <(unzip -p tfplan tfstate-prev) <(unzip -p tfplan tfstate)
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "5120676a-b28b-3935-e18c-a06b83506651",
8c8
<       "value": "green",
---
>       "value": "red",

$ diff <(unzip -p tfplan tfstate) terraform.tfstate
8c8
<       "value": "red",
---
>       "value": "green",

$ terraform apply tfplan
null_resource.color: Destroying... [id=3056772015431020915]
null_resource.color: Destruction complete after 0s
null_resource.color: Creating...
null_resource.color: Provisioning with 'local-exec'...
null_resource.color (local-exec): Executing: ["/bin/sh" "-c" "echo 'red' | tee color.txt"]
null_resource.color (local-exec): red
null_resource.color: Creation complete after 0s [id=5631088929130402692]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

color = "red"

$ cat color.txt
red

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 4,
  "lineage": "5120676a-b28b-3935-e18c-a06b83506651",
  "outputs": {
    "color": {
      "value": "red",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "color",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "5631088929130402692",
            "triggers": {
              "color": "red"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        }
      ]
    }
  ],
  "check_results": null
}

$ ls --almost-all --width=1
.terraform
color.txt
main.tf
.terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
tfplan

$ diff terraform.tfstate.backup terraform.tfstate
4c4
<   "serial": 1,
---
>   "serial": 4,
8c8
<       "value": "green",
---
>       "value": "red",
22c22
<             "id": "3056772015431020915",
---
>             "id": "5631088929130402692",
24c24
<               "color": "green"
---
>               "color": "red"
```

```bash
$ terraform destroy -auto-approve
null_resource.color: Refreshing state... [id=5631088929130402692]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.color will be destroyed
  - resource "null_resource" "color" {
      - id       = "5631088929130402692" -> null
      - triggers = {
          - "color" = "red"
        } -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  - color = "red" -> null
null_resource.color: Destroying... [id=5631088929130402692]
null_resource.color: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 6,
  "lineage": "5120676a-b28b-3935-e18c-a06b83506651",
  "outputs": {},
  "resources": [],
  "check_results": null
}

$ rm --verbose main.tf .terraform.lock.hcl tfplan terraform.tfstate color.txt terraform.tfstate.backup
removed 'main.tf'
removed '.terraform.lock.hcl'
removed 'tfplan'
removed 'terraform.tfstate'
removed 'color.txt'
removed 'terraform.tfstate.backup'

$ rm --recursive .terraform
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
