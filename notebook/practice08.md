# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/tutorials/docker-get-started  
https://registry.terraform.io/providers/calxus/docker/latest/docs

https://www.youtube.com/watch?v=TidvqDcq2Qw&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #8 - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13
[![Debian](img/docker.webp "Docker")](https://www.docker.com)28

```bash
$ cat >main.tf <<EOF
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}
EOF

$ terraform fmt -check -diff

$ terraform providers

Providers required by configuration:
.
└── provider[registry.terraform.io/hashicorp/docker]

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of kreuzwerker/docker...
- Installing kreuzwerker/docker v3.6.2...
- Installed kreuzwerker/docker v3.6.2 (self-signed, key ID BD080C4571C6104C)
Partner and community providers are signed by their developers.
If youʼd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing
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

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id          = (known after apply)
      + image_id    = (known after apply)
      + name        = "nginx:alpine"
      + repo_digest = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ docker image list --no-trunc --quiet

$ terraform apply tfplan
docker_image.nginx: Creating...
docker_image.nginx: Creation complete after 8s [id=sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0
fff4a1cabed9nginx:alpine]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ docker image list --no-trunc --quiet
sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0fff4a1cabed9
```

```bash
$ patch --forward --reject-file=- main.tf <<EOF
12c12
<   name = "nginx:alpine"
---
>   name = "nginx:trixie"
EOF
patching file main.tf

$ cat main.tf | tail --lines=4

resource "docker_image" "nginx" {
  name = "nginx:trixie"
}

$ terraform fmt -check -diff

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan -out=tfplan
docker_image.nginx: Refreshing state... [id=sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0fff4a1c
abed9nginx:alpine]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # docker_image.nginx must be replaced
-/+ resource "docker_image" "nginx" {
      ~ id          = "sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0fff4a1cabed9nginx:alpine" ->
 (known after apply)
      ~ image_id    = "sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0fff4a1cabed9" -> (known afte
r apply)
      ~ name        = "nginx:alpine" -> "nginx:trixie" # forces replacement
      ~ repo_digest = "nginx@sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14" -> (know
n after apply)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
docker_image.nginx: Destroying... [id=sha256:d4918ca78576a537caa7b0c043051c8efc1796de33fee8724ee0fff4a1cabed9n
ginx:alpine]
docker_image.nginx: Destruction complete after 1s
docker_image.nginx: Creating...
docker_image.nginx: Still creating... [00m10s elapsed]
docker_image.nginx: Creation complete after 15s [id=sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a82018896
8dd3e6f06072dnginx:trixie]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

$ docker image list --no-trunc --quiet
sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a820188968dd3e6f06072d
```

```bash
$ terraform destroy -auto-approve
docker_image.nginx: Refreshing state... [id=sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a820188968dd3e6f0
6072dnginx:trixie]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id          = "sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a820188968dd3e6f06072dnginx:trixie" ->
 null
      - image_id    = "sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a820188968dd3e6f06072d" -> null
      - name        = "nginx:trixie" -> null
      - repo_digest = "nginx@sha256:1beed3ca46acebe9d3fb62e9067f03d05d5bfa97a00f30938a0a3580563272ad" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.
docker_image.nginx: Destroying... [id=sha256:d261fd19cb63238535ab80d4e1be1d9e7f6c8b5a28a820188968dd3e6f06072dn
ginx:trixie]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.

$ docker image list --no-trunc --quiet

$ rm --verbose main.tf .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
removed 'main.tf'
removed '.terraform.lock.hcl'
removed 'tfplan'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'

$ rm --recursive .terraform
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
