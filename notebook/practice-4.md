# EXPERIMENT TERRAFORM

## PRACTICE #3 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)
[![Debian](img/debian.webp "Debian")](https://debian.org)

REF: https://www.youtube.com/watch?v=LmHKEiZ1SeA

```bash
$ cat >main.tf <<EOF
variable "colors" {
  default = {
    "green" : "G",
    "orange" : "O",
    "red" : "R"
  }
  type = map(string)
}

resource "null_resource" "colors" {
  for_each = var.colors
  triggers = {
    color = each.key
  }
  provisioner "local-exec" {
    command = "echo '\${each.value} => \${each.key}'"
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

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.colors["green"] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "green"
        }
    }

  # null_resource.colors["orange"] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "orange"
        }
    }

  # null_resource.colors["red"] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "red"
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + colors = {
      + green  = "G"
      + orange = "O"
      + red    = "R"
    }

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

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
      "value": {
        "green": "G",
        "orange": "O",
        "red": "R"
      },
      "type": [
        "map",
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
null_resource.colors["green"]: Creating...
null_resource.colors["red"]: Creating...
null_resource.colors["orange"]: Creating...
null_resource.colors["orange"]: Provisioning with 'local-exec'...
null_resource.colors["red"]: Provisioning with 'local-exec'...
null_resource.colors["red"] (local-exec): Executing: ["/bin/sh" "-c" "echo 'R => red'"]
null_resource.colors["green"]: Provisioning with 'local-exec'...
null_resource.colors["orange"] (local-exec): Executing: ["/bin/sh" "-c" "echo 'O => orange'"]
null_resource.colors["green"] (local-exec): Executing: ["/bin/sh" "-c" "echo 'G => green'"]
null_resource.colors["green"] (local-exec): G => green
null_resource.colors["green"]: Creation complete after 0s [id=1542343123815282101]
null_resource.colors["red"] (local-exec): R => red
null_resource.colors["orange"] (local-exec): O => orange
null_resource.colors["red"]: Creation complete after 0s [id=7182143739922302509]
null_resource.colors["orange"]: Creation complete after 0s [id=4762035047447530473]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

colors = tomap({
  "green" = "G"
  "orange" = "O"
  "red" = "R"
})

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 1,
  "lineage": "402142d9-942c-31c2-232a-2b353b923f35",
  "outputs": {
    "colors": {
      "value": {
        "green": "G",
        "orange": "O",
        "red": "R"
      },
      "type": [
        "map",
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
          "index_key": "green",
          "schema_version": 0,
          "attributes": {
            "id": "1542343123815282101",
            "triggers": {
              "color": "green"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": "orange",
          "schema_version": 0,
          "attributes": {
            "id": "4762035047447530473",
            "triggers": {
              "color": "orange"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": "red",
          "schema_version": 0,
          "attributes": {
            "id": "7182143739922302509",
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
4,5c4,5
<     "orange" : "O",
<     "red" : "R"
---
>     "red" : "R",
>     "yellow": "Y"
EOF
patching file main.tf

$ cat main.tf | head --lines=8
variable "colors" {
  default = {
    "green" : "G",
    "red" : "R",
    "yellow" : "Y"
  }
  type = map(string)
}

$ terraform fmt --check --diff

$ terraform validate
Success! The configuration is valid.

$ terraform plan --out=tfplan
null_resource.colors["orange"]: Refreshing state... [id=4762035047447530473]
null_resource.colors["green"]: Refreshing state... [id=1542343123815282101]
null_resource.colors["red"]: Refreshing state... [id=7182143739922302509]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # null_resource.colors["orange"] will be destroyed
  # (because key ["orange"] is not in for_each map)
  - resource "null_resource" "colors" {
      - id       = "4762035047447530473" -> null
      - triggers = {
          - "color" = "orange"
        } -> null
    }

  # null_resource.colors["yellow"] will be created
  + resource "null_resource" "colors" {
      + id       = (known after apply)
      + triggers = {
          + "color" = "yellow"
        }
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ colors = {
      - orange = "O"
      + yellow = "Y"
        # (2 unchanged attributes hidden)
    }

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ diff <(unzip -p tfplan tfstate-prev) <(unzip -p tfplan tfstate)
4,5c4,5
<   "serial": 0,
<   "lineage": "",
---
>   "serial": 1,
>   "lineage": "402142d9-942c-31c2-232a-2b353b923f35",
10,11c10,11
<         "orange": "O",
<         "red": "R"
---
>         "red": "R",
>         "yellow": "Y"

$ terraform apply tfplan
null_resource.colors["orange"]: Destroying... [id=4762035047447530473]
null_resource.colors["orange"]: Destruction complete after 0s
null_resource.colors["yellow"]: Creating...
null_resource.colors["yellow"]: Provisioning with 'local-exec'...
null_resource.colors["yellow"] (local-exec): Executing: ["/bin/sh" "-c" "echo 'Y => yellow'"]
null_resource.colors["yellow"] (local-exec): Y => yellow
null_resource.colors["yellow"]: Creation complete after 0s [id=3668724608357555791]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

colors = tomap({
  "green" = "G"
  "red" = "R"
  "yellow" = "Y"
})

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 4,
  "lineage": "402142d9-942c-31c2-232a-2b353b923f35",
  "outputs": {
    "colors": {
      "value": {
        "green": "G",
        "red": "R",
        "yellow": "Y"
      },
      "type": [
        "map",
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
          "index_key": "green",
          "schema_version": 0,
          "attributes": {
            "id": "1542343123815282101",
            "triggers": {
              "color": "green"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": "red",
          "schema_version": 0,
          "attributes": {
            "id": "7182143739922302509",
            "triggers": {
              "color": "red"
            }
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0
        },
        {
          "index_key": "yellow",
          "schema_version": 0,
          "attributes": {
            "id": "3668724608357555791",
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
>   "serial": 4,
10,11c10,11
<         "orange": "O",
<         "red": "R"
---
>         "red": "R",
>         "yellow": "Y"
39c39
<           "index_key": "orange",
---
>           "index_key": "red",
42c42
<             "id": "4762035047447530473",
---
>             "id": "7182143739922302509",
44c44
<               "color": "orange"
---
>               "color": "red"
51c51
<           "index_key": "red",
---
>           "index_key": "yellow",
54c54
<             "id": "7182143739922302509",
---
>             "id": "3668724608357555791",
56c56
<               "color": "red"
---
>               "color": "yellow"
```

```bash
$ terraform destroy -auto-approve
null_resource.colors["yellow"]: Refreshing state... [id=3668724608357555791]
null_resource.colors["green"]: Refreshing state... [id=1542343123815282101]
null_resource.colors["red"]: Refreshing state... [id=7182143739922302509]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.colors["green"] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "1542343123815282101" -> null
      - triggers = {
          - "color" = "green"
        } -> null
    }

  # null_resource.colors["red"] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "7182143739922302509" -> null
      - triggers = {
          - "color" = "red"
        } -> null
    }

  # null_resource.colors["yellow"] will be destroyed
  - resource "null_resource" "colors" {
      - id       = "3668724608357555791" -> null
      - triggers = {
          - "color" = "yellow"
        } -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
  - colors = {
      - green  = "G"
      - red    = "R"
      - yellow = "Y"
    } -> null
null_resource.colors["red"]: Destroying... [id=7182143739922302509]
null_resource.colors["green"]: Destroying... [id=1542343123815282101]
null_resource.colors["yellow"]: Destroying... [id=3668724608357555791]
null_resource.colors["red"]: Destruction complete after 0s
null_resource.colors["green"]: Destruction complete after 0s
null_resource.colors["yellow"]: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.

$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.13.1",
  "serial": 8,
  "lineage": "402142d9-942c-31c2-232a-2b353b923f35",
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

[![Monster](img/monster.webp "Boo!")](../README.md)
