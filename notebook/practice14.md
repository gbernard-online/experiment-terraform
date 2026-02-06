# EXPERIMENT TERRAFORM

## REFERENCES

https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs

https://www.youtube.com/watch?v=uAMzDa_0-pE&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #14 - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)24
[![libvirt](img/libvirt.webp "Kubernetes")](https://libvirt.org)10

```bash
$ cat >alpine.sh <<EOF
#!/bin/sh

echo alpine | tee /etc/hostname

echo 'auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
iface eth0 inet6 auto' | tee /etc/network/interfaces

rc-update add networking boot

rc-update add qemu-guest-agent default
EOF

$ chmod --verbose +x alpine.sh
mode of 'alpine.sh' changed from 0664 (rw-rw-r--) to 0775 (rwxrwxr-x)

$ qemu-img create -f qcow2 -q alpine.qcow2 8G
Formatting 'alpine.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=8
589934592 lazy_refcounts=off refcount_bits=16

$ curl --connect-timeout 5 --fail --show-error --silent \
https://raw.githubusercontent.com/alpinelinux/alpine-make-vm-image/refs/heads/master/alpine-make-vm-image |
sudo sh -s -- \
--branch=3.23 --image-format=qcow2 --packages=qemu-guest-agent --script-chroot alpine.qcow2 ./alpine.sh

[...]

$ qemu-img info alpine.qcow2
image: alpine.qcow2
file format: qcow2
virtual size: 8 GiB (8589934592 bytes)
disk size: 285 MiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
Child node '/file':
    filename: alpine.qcow2
    protocol type: file
    file length: 285 MiB (298647552 bytes)
    disk size: 285 MiB

$ sudo virt-customize --add=alpine.qcow2 --password-crypto=sha512 --root-password=password:root
[...]
```

```bash
$ cat >main.tf <<EOF
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
}

resource "libvirt_volume" "alpine" {
  name = "alpine.qcow2"
  pool = "default"

  create = {
    content = {
      url = "file://alpine.qcow2"
    }
  }
  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_domain" "alpine" {
  name        = "alpine"
  memory      = 1
  memory_unit = "GiB"
  type        = "kvm"
  vcpu        = 1

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  devices = {
    channels = [
      {
        source = {
          unix = {}
        }
        target = {
          virt_io = {
            name = "org.qemu.guest_agent.0"
          }
        }
      }
    ]
    disks = [
      {
        driver = {
          name    = "qemu"
          type    = "qcow2"
          discard = "unmap"
        }
        source = {
          volume = {
            pool   = "default"
            volume = libvirt_volume.alpine.name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      }
    ],
    graphics = [
      {
        type = "vnc"
        vnc = {
        }
      }
    ],
    interfaces = [
      {
        type  = "network"
        model = { type = "virtio" }
        source = {
          network = {
            network = "default"
          }
        }
      }
    ],
    videos = [
      {
        model = {
          type    = "virtio"
          primary = "yes"
          heads   = 1
        }
      }
    ]
  }

  running = true
}
EOF

$ terraform fmt -check -diff

$ terraform providers

Providers required by configuration:
.
└── provider[registry.terraform.io/dmacvicar/libvirt]

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of dmacvicar/libvirt...
- Installing dmacvicar/libvirt v0.9.2...
- Installed dmacvicar/libvirt v0.9.2 (self-signed, key ID 0833E38C51E74D26)
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

$ terraform providers schema -json | jq
[...]

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan -out=tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # libvirt_domain.alpine will be created
  + resource "libvirt_domain" "alpine" {
      + devices     = {
          + channels   = [
              + {
                  + source = {
                      + unix = {}
                    }
                  + target = {
                      + virt_io = {
                          + name = "org.qemu.guest_agent.0"
                        }
                    }
                },
            ]
          + disks      = [
              + {
                  + driver = {
                      + discard = "unmap"
                      + name    = "qemu"
                      + type    = "qcow2"
                    }
                  + source = {
                      + volume = {
                          + pool   = "default"
                          + volume = "alpine.qcow2"
                        }
                    }
                  + target = {
                      + bus = "virtio"
                      + dev = "vda"
                    }
                },
            ]
          + graphics   = [
              + {
                  + vnc = {}
                },
            ]
          + interfaces = [
              + {
                  + model  = {
                      + type = "virtio"
                    }
                  + source = {
                      + network = {
                          + network = "default"
                        }
                    }
                },
            ]
          + videos     = [
              + {
                  + model = {
                      + heads   = 1
                      + primary = "yes"
                      + type    = "virtio"
                    }
                },
            ]
        }
      + id          = (known after apply)
      + memory      = 1
      + memory_unit = "GiB"
      + name        = "alpine"
      + os          = {
          + type         = "hvm"
          + type_arch    = "x86_64"
          + type_machine = "q35"
        }
      + running     = true
      + type        = "kvm"
      + uuid        = (known after apply)
      + vcpu        = 1
    }

  # libvirt_volume.alpine will be created
  + resource "libvirt_volume" "alpine" {
      + allocation = (known after apply)
      + capacity   = (known after apply)
      + create     = {
          + content = {
              + url = "file://alpine.qcow2"
            }
        }
      + id         = (known after apply)
      + key        = (known after apply)
      + name       = "alpine.qcow2"
      + path       = (known after apply)
      + physical   = (known after apply)
      + pool       = "default"
      + target     = {
          + format = {
              + type = "qcow2"
            }
          + path   = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ virsh list --all
 Id   Name   State
--------------------

$ terraform apply tfplan
libvirt_volume.alpine: Creating...
libvirt_volume.alpine: Creation complete after 0s [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_domain.alpine: Creating...
libvirt_domain.alpine: Creation complete after 0s [name=alpine]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

$ virsh list --all
 Id   Name     State
------------------------
 1    alpine   running

$ sleep 30

$ virsh shutdown alpine
Domain 'alpine' is being shutdown

$ virsh list --all
 Id   Name     State
-------------------------
 -    alpine   shut off

$ virsh start alpine
Domain 'alpine' started

$ virsh list --all
 Id   Name     State
------------------------
 2    alpine   running

$ sleep 30
```

```bash
$ terraform destroy -auto-approve
libvirt_volume.alpine: Refreshing state... [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_domain.alpine: Refreshing state... [name=alpine]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # libvirt_domain.alpine will be destroyed
  - resource "libvirt_domain" "alpine" {
      - devices     = {
          - channels   = [
              - {
                  - source = {
                      - unix = {} -> null
                    } -> null
                  - target = {
                      - virt_io = {
                          - name = "org.qemu.guest_agent.0" -> null
                        } -> null
                    } -> null
                },
            ] -> null
          - disks      = [
              - {
                  - driver = {
                      - discard = "unmap" -> null
                      - name    = "qemu" -> null
                      - type    = "qcow2" -> null
                    } -> null
                  - source = {
                      - volume = {
                          - pool   = "default" -> null
                          - volume = "alpine.qcow2" -> null
                        } -> null
                    } -> null
                  - target = {
                      - bus = "virtio" -> null
                      - dev = "vda" -> null
                    } -> null
                },
            ] -> null
          - graphics   = [
              - {
                  - vnc = {} -> null
                },
            ] -> null
          - interfaces = [
              - {
                  - model  = {
                      - type = "virtio" -> null
                    } -> null
                  - source = {
                      - network = {
                          - network = "default" -> null
                        } -> null
                    } -> null
                },
            ] -> null
          - videos     = [
              - {
                  - model = {
                      - heads   = 1 -> null
                      - primary = "yes" -> null
                      - type    = "virtio" -> null
                    } -> null
                },
            ] -> null
        } -> null
      - id          = 1 -> null
      - memory      = 1 -> null
      - memory_unit = "GiB" -> null
      - name        = "alpine" -> null
      - os          = {
          - type         = "hvm" -> null
          - type_arch    = "x86_64" -> null
          - type_machine = "q35" -> null
        } -> null
      - running     = true -> null
      - type        = "kvm" -> null
      - uuid        = "72a246f4-ebdc-402d-8a5e-b6bfca266c53" -> null
      - vcpu        = 1 -> null
    }

  # libvirt_volume.alpine will be destroyed
  - resource "libvirt_volume" "alpine" {
      - allocation = 200613888 -> null
      - capacity   = 8589934592 -> null
      - create     = {
          - content = {
              - url = "file://alpine.qcow2" -> null
            } -> null
        } -> null
      - id         = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - key        = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - name       = "alpine.qcow2" -> null
      - path       = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - physical   = 200605696 -> null
      - pool       = "default" -> null
      - target     = {
          - format = {
              - type = "qcow2" -> null
            } -> null
          - path   = "/var/lib/libvirt/images/alpine.qcow2" -> null
        } -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.
libvirt_domain.alpine: Destroying... [name=alpine]
libvirt_domain.alpine: Destruction complete after 1s
libvirt_volume.alpine: Destroying... [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_volume.alpine: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.

$ virsh list --all
 Id   Name   State
--------------------

$ rm --verbose alpine.qcow2 alpine.sh
removed 'alpine.qcow2'
removed 'alpine.sh'

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
