# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/language/expressions/type-constraints  
https://developer.hashicorp.com/terraform/language/meta-arguments/count

https://www.youtube.com/watch?v=LmHKEiZ1SeA&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #3 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13

```bash
$ cat >main.tf <<EOF
variable "colors" {
  type    = list(string)
  default = ["green", "orange", "red"]
}

resource "null_resource" "colors" {
  count = length(var.colors)
  triggers = {
    color = element(var.colors, count.index)
  }
  provisioner "local-exec" {
    command = "echo '\${element(var.colors, count.index)}'"
  }
}

output "colors" {
  value = var.colors
}
EOF

$ terraform fmt --check --diff

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
```

```bash
$ terraform plan --out=tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.colors[0] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "green"
        }
    }

  # null_resource.colors[1] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "orange"
        }
    }

  # null_resource.colors[2] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "red"
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + colors = [
      + "green",
      + "orange",
      + "red",
    ]

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ unzip -p tfplan tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 0,
  "lineage": "",
  "outputs": {
    "colors": {
      "value": [
        "green",
        "orange",
        "red"
      ],
      "type": [
        "list",
        "string"
      ]
    }
  },
  "resources": [],
  "check_results": null
}
```

```bash
$ terraform apply tfplan
null_resource.colors[0]: Creating...
null_resource.colors[1]: Creating...
null_resource.colors[2]: Creating...
null_resource.colors[1]: Provisioning with 'local-exec'...
null_resource.colors[1] (local-exec): Executing: ["/bin/sh" "-c" "echo 'orange'"]
null_resource.colors[0]: Provisioning with 'local-exec'...
null_resource.colors[2]: Provisioning with 'local-exec'...
null_resource.colors[0] (local-exec): Executing: ["/bin/sh" "-c" "echo 'green'"]
null_resource.colors[2] (local-exec): Executing: ["/bin/sh" "-c" "echo 'red'"]
null_resource.colors[2] (local-exec): red
null_resource.colors[1] (local-exec): orange
null_resource.colors[0] (local-exec): green
null_resource.colors[2]: Creation complete after 0s [id=244867919660145630]
null_resource.colors[1]: Creation complete after 0s [id=3760479637787281017]
null_resource.colors[0]: Creation complete after 0s [id=8276275757773130153]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

colors = tolist([
  "green",
  "orange",
  "red",
])

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "b1b3b08e-e2c5-b889-7aba-9038221aad30",
  "outputs": {
    "colors": {
      "value": [
        "green",
        "orange",
        "red"
      ],
      "type": [
        "list",
        "string"
      ]
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "colors",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "index_key": 0,
          "schema_version": 0,
          "attributes": {
            "id": "8276275757773130153",
            "triggers": {
              "color": "green"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": 1,
          "schema_version": 0,
          "attributes": {
            "id": "3760479637787281017",
            "triggers": {
              "color": "orange"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": 2,
          "schema_version": 0,
          "attributes": {
            "id": "244867919660145630",
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
```

```bash
$ patch --forward --reject-file=- main.tf <<EOF
3c2
<   default = ["green", "orange", "red"]
---
>   default = ["green", "red", "yellow"]
EOF
patching file main.tf

$ cat main.tf | head --lines=4
variable "colors" {
  type    = list(string)
  default = ["green", "red", "yellow"]
}

$ terraform fmt --check --diff

$ terraform validate
Success! The configuration is valid.

$ terraform plan --out=tfplan
null_resource.colors[0]: Refreshing state... [id=8276275757773130153]
null_resource.colors[2]: Refreshing state... [id=244867919660145630]
null_resource.colors[1]: Refreshing state... [id=3760479637787281017]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.colors[1] must be replaced
-/+ resource "null_resource" "colors" {
      ~ id       = "3760479637787281017" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "color" = "orange" -> "red"
        }
    }

  # null_resource.colors[2] must be replaced
-/+ resource "null_resource" "colors" {
      ~ id       = "244867919660145630" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "color" = "red" -> "yellow"
        }
    }

Plan: 2 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  ~ colors = [
        "green",
      ~ "orange" -> "red",
      ~ "red" -> "yellow",
    ]

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ diff <(unzip -p tfplan tfstate-prev) <(unzip -p tfplan tfstate)
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "b1b3b08e-e2c5-b889-7aba-9038221aad30",
10,11c10,11
<         "orange",
<         "red"
---
>         "red",
>         "yellow"

$ terraform apply tfplan
null_resource.colors[1]: Destroying... [id=3760479637787281017]
null_resource.colors[2]: Destroying... [id=244867919660145630]
null_resource.colors[2]: Destruction complete after 0s
null_resource.colors[1]: Destruction complete after 0s
null_resource.colors[2]: Creating...
null_resource.colors[1]: Creating...
null_resource.colors[2]: Provisioning with 'local-exec'...
null_resource.colors[2] (local-exec): Executing: ["/bin/sh" "-c" "echo 'yellow'"]
null_resource.colors[1]: Provisioning with 'local-exec'...
null_resource.colors[1] (local-exec): Executing: ["/bin/sh" "-c" "echo 'red'"]
null_resource.colors[2] (local-exec): yellow
null_resource.colors[2]: Creation complete after 0s [id=3975514958148933668]
null_resource.colors[1] (local-exec): red
null_resource.colors[1]: Creation complete after 0s [id=7888409234650180857]

Apply complete! Resources: 2 added, 0 changed, 2 destroyed.

Outputs:

colors = tolist([
  "green",
  "red",
  "yellow",
])

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 6,
  "lineage": "b1b3b08e-e2c5-b889-7aba-9038221aad30",
  "outputs": {
    "colors": {
      "value": [
        "green",
        "red",
        "yellow"
      ],
      "type": [
        "list",
        "string"
      ]
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "colors",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "index_key": 0,
          "schema_version": 0,
          "attributes": {
            "id": "8276275757773130153",
            "triggers": {
              "color": "green"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": 1,
          "schema_version": 0,
          "attributes": {
            "id": "7888409234650180857",
            "triggers": {
              "color": "red"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": 2,
          "schema_version": 0,
          "attributes": {
            "id": "3975514958148933668",
            "triggers": {
              "color": "yellow"
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

$ diff terraform.tfstate.backup terraform.tfstate
4c4
<   "serial": 1,
---
>   "serial": 6,
10,11c10,11
<         "orange",
<         "red"
---
>         "red",
>         "yellow"
42c42
<             "id": "3760479637787281017",
---
>             "id": "7888409234650180857",
44c44
<               "color": "orange"
---
>               "color": "red"
54c54
<             "id": "244867919660145630",
---
>             "id": "3975514958148933668",
56c56
<               "color": "red"
---
>               "color": "yellow"
```

```bash
$ terraform destroy -auto-approve
null_resource.colors[2]: Refreshing state... [id=3975514958148933668]
null_resource.colors[1]: Refreshing state... [id=7888409234650180857]
null_resource.colors[0]: Refreshing state... [id=8276275757773130153]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.colors[0] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "8276275757773130153" -> null
      - triggers = {
          - "color" = "green"
        } -> null
    }

  # null_resource.colors[1] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "7888409234650180857" -> null
      - triggers = {
          - "color" = "red"
        } -> null
    }

  # null_resource.colors[2] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "3975514958148933668" -> null
      - triggers = {
          - "color" = "yellow"
        } -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
  - colors = [
      - "green",
      - "red",
      - "yellow",
    ] -> null
null_resource.colors[0]: Destroying... [id=8276275757773130153]
null_resource.colors[2]: Destroying... [id=3975514958148933668]
null_resource.colors[1]: Destroying... [id=7888409234650180857]
null_resource.colors[1]: Destruction complete after 0s
null_resource.colors[0]: Destruction complete after 0s
null_resource.colors[2]: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 10,
  "lineage": "b1b3b08e-e2c5-b889-7aba-9038221aad30",
  "outputs": {},
  "resources": [],
  "check_results": null
}

$ rm --verbose main.tf .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan
removed 'main.tf'
removed '.terraform.lock.hcl'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'
removed 'tfplan'

$ rm --recursive .terraform
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
