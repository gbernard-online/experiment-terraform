# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/install

https://www.youtube.com/watch?v=7gtzumVHZtE&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## INSTALL - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13


```bash
$ curl --fail --show-error --silent https://apt.releases.hashicorp.com/gpg |
sudo dd of=/etc/apt/trusted.gpg.d/hashicorp.asc status=none

$ sudo dd of=/etc/apt/sources.list.d/hashicorp.list status=none <<EOF
deb [arch=amd64] https://apt.releases.hashicorp.com trixie main
EOF

$ sudo apt --quiet=2 update
All packages are up to date.

$ apt-cache policy terraform | head --lines=6
terraform:
  Installed: (none)
  Candidate: 1.13.1-1
  Version table:
     1.13.1-1 500
        500 https://apt.releases.hashicorp.com trixie/main amd64 Packages

$ apt depends terraform
terraform
  Depends: git

$ sudo apt install --no-install-recommends --quiet=2 --yes terraform
Installing:
  terraform

Summary:
  Upgrading: 0, Installing: 1, Removing: 0, Not Upgrading: 0
  Download size: 30.3 MB
  Space needed: 100 MB / 7,949 MB available
|...|

$ ls --width=1 /usr/share/doc/terraform
LICENSE.txt

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

## INSTALL - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)24

```bash
$ curl --fail --show-error --silent https://apt.releases.hashicorp.com/gpg |
sudo dd of=/etc/apt/trusted.gpg.d/hashicorp.asc status=none

$ sudo dd of=/etc/apt/sources.list.d/hashicorp.list status=none <<EOF
deb [arch=amd64] https://apt.releases.hashicorp.com noble main
EOF

$ sudo apt --quiet=2 update
All packages are up to date.

$ apt --option=Apt::Cmd::Disable-Script-Warning=true policy terraform | head --lines=6
terraform:
  Installed: (none)
  Candidate: 1.13.1-1
  Version table:
     1.13.1-1 500
        500 https://apt.releases.hashicorp.com noble/main amd64 Packages

$ apt depends terraform
terraform
  Depends: git

$ sudo apt install --no-install-recommends --quiet=2 --yes terraform
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 30.3 MB of archives.
|...|

$ ls --width=1 /usr/share/doc/terraform
LICENSE.txt

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

## INSTALL - TERRAFORM - ARCHLINUX

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Archlinux](img/archlinux.webp "Archlinux")](https://archlinux.org)X

```bash
$ pacman --sync --info terraform
Repository      : extra
Name            : terraform
Version         : 1.13.1-1
Description     : HashiCorp tool for building and updating infrastructure as code idempotently
Architecture    : x86_64
URL             : https://github.com/hashicorp/terraform
Licenses        : BUSL-1.1
Groups          : None
Provides        : terragrunt-iac-provider
Depends On      : glibc
Optional Deps   : diffutils: for running `terraform fmt -diff`
Conflicts With  : None
Replaces        : None
Download Size   : 21.01 MiB
Installed Size  : 96.02 MiB
Packager        : Justin Kromlinger <hashworks@archlinux.org>
Build Date      : Fri 29 Aug 2025 03:32:56 PM CEST
Validated By    : SHA-256 Sum  Signature

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

$ ls --width=1 /usr/share/licenses/terraform
LICENSE

$ whereis terraform
terraform: /usr/bin/terraform

$ terraform --version
Terraform v1.13.1
on linux_amd64
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
