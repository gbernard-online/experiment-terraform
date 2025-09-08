# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/install

https://www.youtube.com/watch?v=7gtzumVHZtE&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx&index=2

## INSTALL - TERRAFORM - DEBIAN 13

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Debian](img/debian.webp "Debian")](https://debian.org)13


```bash
$ curl --fail --show-error --silent https://apt.releases.hashicorp.com/gpg |
sudo dd of=/etc/apt/trusted.gpg.d/hashicorp.asc status=none

$ sudo dd of=/etc/apt/sources.list.d/hashicorp.list status=none <<EOF
deb [arch=amd64] https://apt.releases.hashicorp.com trixie main
EOF

$ sudo apt-get update
Hit:1 http://security.debian.org/debian-security trixie-security InRelease
Hit:2 http://deb.debian.org/debian trixie InRelease
Hit:3 http://deb.debian.org/debian trixie-updates InRelease
Hit:4 https://download.docker.com/linux/debian trixie InRelease
Hit:5 https://apt.releases.hashicorp.com trixie InRelease
Reading package lists... Done

$ apt-cache policy terraform | head --lines=6
terraform:
  Installed: (none)
  Candidate: 1.13.1-1
  Version table:
     1.13.1-1 500
        500 https://apt.releases.hashicorp.com trixie/main amd64 Packages

$ apt depends podman terraform
podman
  Depends: conmon
 |Depends: crun
  Depends: runc
    containerd.io
  Depends: golang-github-containers-common
  Depends: netavark
  Depends: init-system-helpers (>= 1.52)
  Depends: libc6 (>= 2.38)
  Depends: libgpgme11t64 (>= 1.23.2)
  Depends: libseccomp2 (>= 2.5.0)
  Depends: libsqlite3-0 (>= 3.36.0)
  Depends: libsubid5 (>= 1:4.16.0)
  Recommends: buildah (>= 1.31)
  Recommends: ca-certificates
 |Recommends: catatonit
 |Recommends: tini
  Recommends: dumb-init
  Recommends: containers-storage
  Recommends: criu
  Recommends: dbus-user-session
  Recommends: libcriu2
  Recommends: passt
  Recommends: slirp4netns
  Recommends: uidmap
  Suggests: containernetworking-plugins
  Suggests: docker-compose
  Suggests: iptables
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

$ ls /usr/share/doc/terraform
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

$ sudo apt-get update
Hit:1 http://archive.ubuntu.com/ubuntu noble InRelease
Hit:2 https://download.docker.com/linux/ubuntu noble InRelease
Get:3 https://apt.releases.hashicorp.com noble InRelease [12.9 kB]
Get:4 http://archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:5 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:6 http://archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Hit:7 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.34/deb  InRelease
Get:8 https://apt.releases.hashicorp.com noble/main amd64 Packages [200 kB]
Get:9 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1,118 kB]
Get:10 http://security.ubuntu.com/ubuntu noble-security/main amd64 Components [21.6 kB]
Get:11 http://security.ubuntu.com/ubuntu noble-security/restricted amd64 Components [212 B]
Get:12 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Packages [879 kB]
Get:13 http://security.ubuntu.com/ubuntu noble-security/universe amd64 Components [52.3 kB]
Get:14 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Components [208 B]
Get:15 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1,389 kB]
Get:16 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Components [175 kB]
Get:17 http://archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Components [212 B]
Get:18 http://archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1,481 kB]
Get:19 http://archive.ubuntu.com/ubuntu noble-updates/universe amd64 Components [377 kB]
Get:20 http://archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Components [940 B]
Get:21 http://archive.ubuntu.com/ubuntu noble-backports/main amd64 Components [7,076 B]
Get:22 http://archive.ubuntu.com/ubuntu noble-backports/restricted amd64 Components [216 B]
Get:23 http://archive.ubuntu.com/ubuntu noble-backports/universe amd64 Components [19.2 kB]
Get:24 http://archive.ubuntu.com/ubuntu noble-backports/multiverse amd64 Components [212 B]
Fetched 6,114 kB in 2s (3,584 kB/s) 
Reading package lists... Done

$ apt --option=Apt::Cmd::Disable-Script-Warning=true policy terraform | head --lines=6
terraform:
  Installed: (none)
  Candidate: 1.13.1-1
  Version table:
     1.13.1-1 500
        500 https://apt.releases.hashicorp.com noble/main amd64 Packages

$ apt depends podman terraform
podman
  Depends: conmon
 |Depends: crun
  Depends: runc
    containerd.io
  Depends: golang-github-containers-common
  Depends: libc6 (>= 2.38)
  Depends: libdevmapper1.02.1 (>= 2:1.02.97)
  Depends: libgpgme11t64 (>= 1.4.1)
  Depends: libseccomp2 (>= 2.5.0)
  Depends: libsqlite3-0 (>= 3.36.0)
  Depends: libsubid4 (>= 1:4.11.1)
  Recommends: buildah (>= 1.31)
 |Recommends: catatonit
 |Recommends: tini
  Recommends: dumb-init
  Recommends: dbus-user-session
  Recommends: passt
  Recommends: slirp4netns
  Recommends: uidmap
  Suggests: containers-storage
  Suggests: docker-compose
  Suggests: iptables
terraform
  Depends: git

$ sudo apt install --no-install-recommends --quiet=2 --yes terraform
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 30.3 MB of archives.
|...|

$ ls /usr/share/doc/terraform
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

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
