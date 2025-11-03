# EXPERIMENT TERRAFORM

## REFERENCES

https://www.youtube.com/watch?v=vh58fGiGj-A&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx  
https://www.youtube.com/watch?v=huR8567SSQQ&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #7 - TERRAFORM - DEBIAN 13

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
  connection {
    user     = "$USER"
    host     = "localhost"
    host_key = file("/etc/ssh/ssh_host_ecdsa_key.pub")
  }
  provisioner "local-exec" {
    command = "echo '\${var.color}' | tee color.txt"
  }
  provisioner "file" {
    source      = "color.txt"
    destination = "/tmp/color.txt"
  }
}

output "color" {
  value = var.color
}
EOF

$ terraform fmt -check -diff

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
$ terraform plan -out=tfplan

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

$ unzip -p tfplan tfstate
{
  "version": 4,
  "terraform_version": "1.13.4",
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
```

```bash
$ $ terraform apply tfplan
null_resource.color: Creating...
null_resource.color: Provisioning with 'local-exec'...
null_resource.color (local-exec): Executing: ["/bin/sh" "-c" "echo 'green' | tee color.txt"]
null_resource.color (local-exec): green
null_resource.color: Provisioning with 'file'...
null_resource.color: Creation complete after 0s [id=5414372728069682176]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

color = "green"

$ cat color.txt
green

$ cat /tmp/color.txt
green
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
null_resource.color: Refreshing state... [id=5414372728069682176]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.color must be replaced
-/+ resource "null_resource" "color" {
      ~ id       = "5414372728069682176" -> (known after apply)
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

$ terraform apply tfplan
null_resource.color: Destroying... [id=5414372728069682176]
null_resource.color: Destruction complete after 0s
null_resource.color: Creating...
null_resource.color: Provisioning with 'local-exec'...
null_resource.color (local-exec): Executing: ["/bin/sh" "-c" "echo 'red' | tee color.txt"]
null_resource.color (local-exec): red
null_resource.color: Provisioning with 'file'...
null_resource.color: Creation complete after 0s [id=6193546058216442499]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

color = "red"

$ cat color.txt
red

$ cat /tmp/color.txt
red

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
<             "id": "5414372728069682176",
---
>             "id": "6193546058216442499",
24c24
<               "color": "green"
---
>               "color": "red"
```

```bash
$ terraform destroy -auto-approve
null_resource.color: Refreshing state... [id=6193546058216442499]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.color will be destroyed
  - resource "null_resource" "color" {
      - id       = "6193546058216442499" -> null
      - triggers = {
          - "color" = "red"
        } -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  - color = "red" -> null
null_resource.color: Destroying... [id=6193546058216442499]
null_resource.color: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.

$ rm --verbose main.tf .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
removed 'main.tf'
removed '.terraform.lock.hcl'
removed 'tfplan'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'

$ rm --verbose color.txt /tmp/color.txt
removed 'color.txt'
removed '/tmp/color.txt'

$ rm --recursive .terraform
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
