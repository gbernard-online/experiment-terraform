# EXPERIMENT TERRAFORM

## REFERENCES

https://www.youtube.com/watch?v=TidvqDcq2Qw&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx  
https://www.youtube.com/watch?v=_Spp_xAq0r4&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #9 - TERRAFORM - DEBIAN 13

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

data "docker_registry_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
}
EOF

$ terraform fmt -check -diff

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
data.docker_registry_image.nginx: Reading...
data.docker_registry_image.nginx: Read complete after 1s [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32
f646adcf92441b72f82b14]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id            = (known after apply)
      + image_id      = (known after apply)
      + name          = "nginx:alpine"
      + pull_triggers = [
          + "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14",
        ]
      + repo_digest   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ docker image list --no-trunc --quiet

$ terraform apply tfplan
docker_image.nginx: Creating...
docker_image.nginx: Creation complete after 4s [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92
441b72f82b14nginx:alpine]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ docker image list --no-trunc --quiet
sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14
```

```bash
$ cat >>main.tf <<EOF

resource "docker_container" "nginx" {
  hostname = "ngin.local"
  image    = docker_image.nginx.image_id
  name     = "nginx"
  restart  = "unless-stopped"
  ports {
    internal = 80
    external = 80
    ip       = ""
  }
}
EOF

$ terraform fmt -check -diff

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan -out=tfplan
data.docker_registry_image.nginx: Reading...
data.docker_registry_image.nginx: Read complete after 1s [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32
f646adcf92441b72f82b14]
docker_image.nginx: Refreshing state... [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f
82b14nginx:alpine]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx will be created
  + resource "docker_container" "nginx" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = "nginx.local"
      + id                                          = (known after apply)
      + image                                       = "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646ad
cf92441b72f82b14"
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "nginx"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "unless-stopped"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 80
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ docker container list --quiet

$ terraform apply tfplan
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 1s [id=6222c977933fc90f8560b3b32aaef9687c1a66ae59ac4539e70680b
464f64cfe]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ docker container list --no-trunc --quiet
fcab012717e1e9772b9df7567d44da78150f371ab76d70d6c6abe437eac3f94b

$ curl --connect-timeout 5 --fail --ipv4 --show-error --silent localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
|...|

$ curl --connect-timeout 5 --fail --ipv6 --show-error --silent localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
|...|
```

```bash
$ terraform destroy -auto-approve
data.docker_registry_image.nginx: Reading...
data.docker_registry_image.nginx: Read complete after 1s [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32
f646adcf92441b72f82b14]
docker_image.nginx: Refreshing state... [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f
82b14nginx:alpine]
docker_container.nginx: Refreshing state... [id=fcab012717e1e9772b9df7567d44da78150f371ab76d70d6c6abe437eac3f9
4b]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # docker_container.nginx will be destroyed
  - resource "docker_container" "nginx" {
      - attach                                      = false -> null
      - command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> null
      - container_read_refresh_timeout_milliseconds = 15000 -> null
      - cpu_shares                                  = 0 -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      - entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> null
      - env                                         = [] -> null
      - group_add                                   = [] -> null
      - hostname                                    = "ngin.local" -> null
      - id                                          = "fcab012717e1e9772b9df7567d44da78150f371ab76d70d6c6abe43
    7eac3f94b" -> null
      - image                                       = "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646ad
    cf92441b72f82b14" -> null
      - init                                        = false -> null
      - ipc_mode                                    = "private" -> null
      - log_driver                                  = "json-file" -> null
      - log_opts                                    = {} -> null
      - logs                                        = false -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_swap                                 = 0 -> null
      - must_run                                    = true -> null
      - name                                        = "nginx" -> null
      - network_data                                = [
          - {
              - gateway                   = "172.17.0.1"
              - global_ipv6_address       = "fd7f:e996:4f39:5d47::2"
              - global_ipv6_prefix_length = 80
              - ip_address                = "172.17.0.2"
              - ip_prefix_length          = 24
              - ipv6_gateway              = "fd7f:e996:4f39:5d47::1"
              - mac_address               = "da:e0:8a:a2:31:1c"
              - network_name              = "bridge"
            },
        ] -> null
      - network_mode                                = "bridge" -> null
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      - read_only                                   = false -> null
      - remove_volumes                              = true -> null
      - restart                                     = "unless-stopped" -> null
      - rm                                          = false -> null
      - runtime                                     = "runc" -> null
      - security_opts                               = [] -> null
      - shm_size                                    = 64 -> null
      - start                                       = true -> null
      - stdin_open                                  = false -> null
      - stop_signal                                 = "SIGQUIT" -> null
      - stop_timeout                                = 0 -> null
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
      - tty                                         = false -> null
      - wait                                        = false -> null
      - wait_timeout                                = 60 -> null
      - working_dir                                 = "/" -> null
        # (6 unchanged attributes hidden)

      - ports {
          - external = 80 -> null
          - internal = 80 -> null
          - ip       = "0.0.0.0" -> null
          - protocol = "tcp" -> null
        }
      - ports {
          - external = 80 -> null
          - internal = 80 -> null
          - ip       = "::" -> null
          - protocol = "tcp" -> null
        }
    }

  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id            = "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14nginx:alpine"
-> null
      - image_id      = "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14" -> null
      - name          = "nginx:alpine" -> null
      - pull_triggers = [
          - "sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14",
        ] -> null
      - repo_digest   = "nginx@sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14" -> nul
l
    }

Plan: 0 to add, 0 to change, 2 to destroy.
docker_container.nginx: Destroying... [id=fcab012717e1e9772b9df7567d44da78150f371ab76d70d6c6abe437eac3f94b]
docker_container.nginx: Destruction complete after 0s
docker_image.nginx: Destroying... [id=sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14n
ginx:alpine]
docker_image.nginx: Destruction complete after 1s

Destroy complete! Resources: 2 destroyed.

$ docker container list --quiet

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
