# EXPERIMENT TERRAFORM

## INSTALL - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)
[![Debian](img/debian.webp "Debian")](https://debian.org)

REF: https://developer.hashicorp.com/terraform/install

```bash
$ apt-cache policy terraform | head --lines=7
terraform:
  Installed: 1.13.1-1
  Candidate: 1.13.1-1
  Version table:
 *** 1.13.1-1 500
        500 https://apt.releases.hashicorp.com trixie/main amd64 Packages
        100 /var/lib/dpkg/status

$ ls /usr/share/doc/terraform
LICENSE.txt

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

## INSTALL - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)

REF: https://developer.hashicorp.com/terraform/install

```bash
$ apt-cache policy terraform | head --lines=7
terraform:
  Installed: 1.13.1-1
  Candidate: 1.13.1-1
  Version table:
 *** 1.13.1-1 500
        500 https://apt.releases.hashicorp.com noble/main amd64 Packages
        100 /var/lib/dpkg/status

$ ls /usr/share/doc/terraform
LICENSE.txt

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

## INSTALL - TERRAFORM - ARCHLINUX

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)
[![Archlinux](img/archlinux.webp "Archlinux")](https://archlinux.org)

```bash
$ sudo pacman --noconfirm --noprogressbar --sync terraform
resolving dependencies...
looking for conflicting packages...

Packages (1) terraform-1.13.1-1

Total Installed Size:  96.02 MiB

:: Proceed with installation? [Y/n]
checking keyring...
checking package integrity...
loading package files...
checking for file conflicts...
checking available disk space...
:: Processing package changes...
installing terraform...
Optional dependencies for terraform
    diffutils: for running `terraform fmt -diff` [installed]
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...

$ ls /usr/share/licenses/terraform
LICENSE

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

&nbsp;

`-`

[![Monster](img/monster.webp "Boo!")](../README.md)
