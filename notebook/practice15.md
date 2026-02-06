EXPERIMENT TERRAFORM

## REFERENCES

https://cloudinit.readthedocs.io/en/latest

https://www.youtube.com/watch?v=RQWNXESaLn8&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #15 - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)24
[![libvirt](img/libvirt.webp "Kubernetes")](https://libvirt.org)10

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

resource "libvirt_volume" "alpine-base" {
  name = "alpine-base.qcow2"
  pool = "default"

  create = {
    content = {
      url = join("/", [
        "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/cloud",
        "generic_alpine-3.23.2-x86_64-bios-cloudinit-r0.qcow2"
      ])
    }
  }
  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_volume" "alpine" {
  name     = "alpine.qcow2"
  pool     = "default"
  capacity = 4294967296

  backing_store = {
    path = libvirt_volume.alpine-base.path
    format = {
      type = "qcow2"
    }
  }
  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_cloudinit_disk" "alpine" {
  name = "alpine"

  meta_data = <<-EOT
    local-hostname: alpine
  EOT

  network_config = <<-EOT
    version: 2
    ethernets:
      eth0:
        dhcp4: true
  EOT

  user_data = <<-EOT
    #cloud-config
    chpasswd:
      expire: false
      users:
        - name: alpine
          password: alpine
          type: text
    ssh:
      emit_keys_to_console: false
    ssh_pwauth: true
  EOT
}

resource "libvirt_volume" "alpine-seed" {
  name = "alpine-seed.iso"
  pool = "default"

  create = {
    content = {
      url = libvirt_cloudinit_disk.alpine.path
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
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.alpine-seed.pool
            volume = libvirt_volume.alpine-seed.name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
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

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan -out=tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # libvirt_cloudinit_disk.alpine will be created
  + resource "libvirt_cloudinit_disk" "alpine" {
      + id             = (known after apply)
      + meta_data      = ＜＜-EOT
            local-hostname: alpine
        EOT
      + name           = "alpine"
      + network_config = ＜＜-EOT
            version: 2
            ethernets:
              eth0:
                dhcp4: true
        EOT
      + path           = (known after apply)
      + size           = (known after apply)
      + user_data      = ＜＜-EOT
            #cloud-config
            chpasswd:
              expire: false
              users:
                - name: alpine
                  password: alpine
                  type: text
            ssh:
              emit_keys_to_console: false
            ssh_pwauth: true
        EOT
    }

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
              + {
                  + device = "cdrom"
                  + source = {
                      + volume = {
                          + pool   = "default"
                          + volume = "alpine-seed.iso"
                        }
                    }
                  + target = {
                      + bus = "sata"
                      + dev = "sda"
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
      + allocation    = (known after apply)
      + backing_store = {
          + format = {
              + type = "qcow2"
            }
          + path   = (known after apply)
        }
      + capacity      = 4294967296
      + id            = (known after apply)
      + key           = (known after apply)
      + name          = "alpine.qcow2"
      + path          = (known after apply)
      + physical      = (known after apply)
      + pool          = "default"
      + target        = {
          + format = {
              + type = "qcow2"
            }
          + path   = (known after apply)
        }
    }

  # libvirt_volume.alpine-base will be created
  + resource "libvirt_volume" "alpine-base" {
      + allocation = (known after apply)
      + capacity   = (known after apply)
      + create     = {
          + content = {
              + url = "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/cloud/generic_alpine-3.2
3.2-x86_64-bios-cloudinit-r0.qcow2"
            }
        }
      + id         = (known after apply)
      + key        = (known after apply)
      + name       = "alpine-base.qcow2"
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

  # libvirt_volume.alpine-seed will be created
  + resource "libvirt_volume" "alpine-seed" {
      + allocation = (known after apply)
      + capacity   = (known after apply)
      + create     = {
          + content = {
              + url = (known after apply)
            }
        }
      + id         = (known after apply)
      + key        = (known after apply)
      + name       = "alpine-seed.iso"
      + path       = (known after apply)
      + physical   = (known after apply)
      + pool       = "default"
    }

Plan: 5 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ virsh list --all
 Id   Name   State
--------------------

$ terraform apply tfplan
libvirt_cloudinit_disk.alpine: Creating...
libvirt_cloudinit_disk.alpine: Creation complete after 0s [id=a4534b3949328962]
libvirt_volume.alpine-base: Creating...
libvirt_volume.alpine-seed: Creating...
libvirt_volume.alpine-seed: Creation complete after 0s [id=/var/lib/libvirt/images/alpine-seed.iso]
libvirt_volume.alpine-base: Creation complete after 3s [id=/var/lib/libvirt/images/alpine-base.qcow2]
libvirt_volume.alpine: Creating...
libvirt_volume.alpine: Creation complete after 0s [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_domain.alpine: Creating...
libvirt_domain.alpine: Creation complete after 0s [name=alpine]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

$ virsh list --all
 Id   Name     State
------------------------
 1    alpine   running

$ sleep 60

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

$ sleep 60
```

```bash
$ terraform destroy -auto-approve
libvirt_cloudinit_disk.alpine: Refreshing state... [id=a4534b3949328962]
libvirt_volume.alpine-base: Refreshing state... [id=/var/lib/libvirt/images/alpine-base.qcow2]
libvirt_volume.alpine-seed: Refreshing state... [id=/var/lib/libvirt/images/alpine-seed.iso]
libvirt_volume.alpine: Refreshing state... [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_domain.alpine: Refreshing state... [name=alpine]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # libvirt_cloudinit_disk.alpine will be destroyed
  - resource "libvirt_cloudinit_disk" "alpine" {
      - id             = "a4534b3949328962" -> null
      - meta_data      = ＜＜-EOT
            local-hostname: alpine
        EOT -> null
      - name           = "alpine" -> null
      - network_config = ＜＜-EOT
            version: 2
            ethernets:
              eth0:
                dhcp4: true
        EOT -> null
      - path           = "/tmp/terraform-provider-libvirt-cloudinit/cloudinit-a4534b3949328962.iso" 
-> null
      - size           = 45056 -> null
      - user_data      = ＜＜-EOT
            #cloud-config
            chpasswd:
              expire: false
              users:
                - name: alpine
                  password: alpine
                  type: text
            ssh:
              emit_keys_to_console: false
            ssh_pwauth: true
        EOT -> null
    }

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
              - {
                  - device = "cdrom" -> null
                  - source = {
                      - volume = {
                          - pool   = "default" -> null
                          - volume = "alpine-seed.iso" -> null
                        } -> null
                    } -> null
                  - target = {
                      - bus = "sata" -> null
                      - dev = "sda" -> null
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
      - id          = 2 -> null
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
      - uuid        = "a81c15c7-0541-4237-a252-a2844e06cddf" -> null
      - vcpu        = 1 -> null
    }

  # libvirt_volume.alpine will be destroyed
  - resource "libvirt_volume" "alpine" {
      - allocation    = 264478720 -> null
      - backing_store = {
          - format = {
              - type = "qcow2" -> null
            } -> null
          - path   = "/var/lib/libvirt/images/alpine-base.qcow2" -> null
        } -> null
      - capacity      = 4294967296 -> null
      - id            = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - key           = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - name          = "alpine.qcow2" -> null
      - path          = "/var/lib/libvirt/images/alpine.qcow2" -> null
      - physical      = 264503296 -> null
      - pool          = "default" -> null
      - target        = {
          - format = {
              - type = "qcow2" -> null
            } -> null
          - path   = "/var/lib/libvirt/images/alpine.qcow2" -> null
        } -> null
    }

  # libvirt_volume.alpine-base will be destroyed
  - resource "libvirt_volume" "alpine-base" {
      - allocation = 191954944 -> null
      - capacity   = 209715200 -> null
      - create     = {
          - content = {
              - url = "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/cloud/generic_alpine-3.2
3.2-x86_64-bios-cloudinit-r0.qcow2" -> null
            } -> null
        } -> null
      - id         = "/var/lib/libvirt/images/alpine-base.qcow2" -> null
      - key        = "/var/lib/libvirt/images/alpine-base.qcow2" -> null
      - name       = "alpine-base.qcow2" -> null
      - path       = "/var/lib/libvirt/images/alpine-base.qcow2" -> null
      - physical   = 191954944 -> null
      - pool       = "default" -> null
      - target     = {
          - format = {
              - type = "qcow2" -> null
            } -> null
          - path   = "/var/lib/libvirt/images/alpine-base.qcow2" -> null
        } -> null
    }

  # libvirt_volume.alpine-seed will be destroyed
  - resource "libvirt_volume" "alpine-seed" {
      - allocation = 45056 -> null
      - capacity   = 45056 -> null
      - create     = {
          - content = {
              - url = "/tmp/terraform-provider-libvirt-cloudinit/cloudinit-a4534b3949328962.iso" -> 
null
            } -> null
        } -> null
      - id         = "/var/lib/libvirt/images/alpine-seed.iso" -> null
      - key        = "/var/lib/libvirt/images/alpine-seed.iso" -> null
      - name       = "alpine-seed.iso" -> null
      - path       = "/var/lib/libvirt/images/alpine-seed.iso" -> null
      - physical   = 45056 -> null
      - pool       = "default" -> null
    }

Plan: 0 to add, 0 to change, 5 to destroy.
libvirt_domain.alpine: Destroying... [name=alpine]
libvirt_domain.alpine: Destruction complete after 1s
libvirt_volume.alpine-seed: Destroying... [id=/var/lib/libvirt/images/alpine-seed.iso]
libvirt_volume.alpine: Destroying... [id=/var/lib/libvirt/images/alpine.qcow2]
libvirt_volume.alpine-seed: Destruction complete after 0s
libvirt_cloudinit_disk.alpine: Destroying... [id=a4534b3949328962]
libvirt_cloudinit_disk.alpine: Destruction complete after 0s
libvirt_volume.alpine: Destruction complete after 0s
libvirt_volume.alpine-base: Destroying... [id=/var/lib/libvirt/images/alpine-base.qcow2]
libvirt_volume.alpine-base: Destruction complete after 0s

Destroy complete! Resources: 5 destroyed.

$ virsh list --all
 Id   Name   State
--------------------

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
