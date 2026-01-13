# EXPERIMENT TERRAFORM

## REFERENCES

https://wintelguy.com/2025/understanding-terraform-variable-precedence.html

https://www.youtube.com/watch?v=4l_y3D58_iE&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #5 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13

```bash
$ cat >main.tf <<EOF
variable "variable" {
  type    = string
  default = "main.tf"
}

output "variable" {
  value = var.variable
}
EOF

$ terraform fmt -check -diff

$ terraform apply -auto-approve

Changes to Outputs:
  + variable = "main.tf"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "main.tf"

$ terraform output
{
  "value": "main.tf",
  "type": "string"
}
```

```bash
$ TF_VAR_variable=TF_VAR_variable terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "main.tf" -> "TF_VAR_variable"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "TF_VAR_variable"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "TF_VAR_variable",
  "type": "string"
}

$ cat terraform.tfstate.backup | jq .outputs.variable
{
  "value": "main.tf",
  "type": "string"
}
```

```bash
$ cat >terraform.tfvars <<EOF
variable = "terraform.tfvars"
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "TF_VAR_variable" -> "terraform.tfvars"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "terraform.tfvars"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "terraform.tfvars",
  "type": "string"
}

$ cat >terraform.tfvars.json <<EOF
{
  "variable": "terraform.tfvars.json"
}
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "terraform.tfvars" -> "terraform.tfvars.json"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "terraform.tfvars.json"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "terraform.tfvars.json",
  "type": "string"
}
```


```bash
cat >1.auto.tfvars <<EOF
variable = "1.auto.tfvars"
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "terraform.tfvars.json" -> "1.auto.tfvars"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "1.auto.tfvars"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "1.auto.tfvars",
  "type": "string"
}

cat >1.auto.tfvars.json <<EOF
{
  "variable": "1.auto.tfvars.json"
}
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "1.auto.tfvars" -> "1.auto.tfvars.json"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "1.auto.tfvars.json"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "1.auto.tfvars.json",
  "type": "string"
}

$ cat >2.auto.tfvars <<EOF
variable = "2.auto.tfvars"
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "1.auto.tfvars.json" -> "2.auto.tfvars"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "2.auto.tfvars"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "2.auto.tfvars",
  "type": "string"
}

$ cat >2.auto.tfvars.json <<EOF
{
  "variable": "2.auto.tfvars.json"
}
EOF

$ terraform apply -auto-approve

Changes to Outputs:
  ~ variable = "2.auto.tfvars" -> "2.auto.tfvars.json"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "2.auto.tfvars.json"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "2.auto.tfvars.json",
  "type": "string"
}
```

```bash
$ terraform apply -auto-approve -var='variable=-var'

Changes to Outputs:
  ~ variable = "2.auto.tfvars.json" -> "-var"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "-var"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "-var",
  "type": "string"
}

$ terraform apply -auto-approve -var='variable=-var' -var-file=<(echo 'variable = "-var-file"')

Changes to Outputs:
  ~ variable = "-var" -> "-var-file"

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

variable = "-var-file"

$ cat terraform.tfstate | jq .outputs.variable
{
  "value": "-var-file",
  "type": "string"
}
```

```bash
$ terraform destroy -auto-approve -var='variable=-var' -var-file=<(echo 'variable = "-var-file"')

Changes to Outputs:
  - variable = "-var-file" -> null

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Destroy complete! Resources: 0 destroyed.

$ rm --verbose main.tf terraform.tfstate terraform.tfstate.backup
removed 'main.tf'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'

$ rm --verbose terraform.tfvars{,.json} {1,2}.auto.tfvars{,.json}
removed 'terraform.tfvars'
removed 'terraform.tfvars.json'
removed '1.auto.tfvars'
removed '1.auto.tfvars.json'
removed '2.auto.tfvars'
removed '2.auto.tfvars.json'
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
