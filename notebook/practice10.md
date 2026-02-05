# EXPERIMENT TERRAFORM

## REFERENCES

https://developer.hashicorp.com/terraform/tutorials/kubernetes  
https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider  
https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs  
https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1

https://www.youtube.com/watch?v=onfZmhADZMg&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #10 - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)24
[![Kubernetes](img/kubernetes.webp "Kubernetes")](https://kubernetes.io)1
[![MicroK8s](img/microk8s.webp "MikroK8s")](https://microk8s.io)1

```bash
$ export KUBE_CONFIG_PATH=/var/snap/microk8s/current/credentials/client.config

$ cat >main.tf <<EOF
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {}

resource "kubernetes_pod_v1" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    container {
      image = "nginx:alpine"
      name  = "nginx"
    }
  }
}
EOF

$ terraform fmt -check -diff

$ terraform providers

Providers required by configuration:
.
└── provider[registry.terraform.io/hashicorp/kubernetes]

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/kubernetes...
- Installing hashicorp/kubernetes v3.0.1...
- Installed hashicorp/kubernetes v3.0.1 (signed by HashiCorp)
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

  # kubernetes_pod_v1.nginx will be created
  + resource "kubernetes_pod_v1" "nginx" {
      + id = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "nginx"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + automount_service_account_token  = true
          + dns_policy                       = "ClusterFirst"
          + enable_service_links             = true
          + host_ipc                         = false
          + host_network                     = false
          + host_pid                         = false
          + hostname                         = (known after apply)
          + node_name                        = (known after apply)
          + restart_policy                   = "Always"
          + scheduler_name                   = (known after apply)
          + service_account_name             = (known after apply)
          + share_process_namespace          = false
          + termination_grace_period_seconds = 30

          + container {
              + image                      = "nginx:alpine"
              + image_pull_policy          = (known after apply)
              + name                       = "nginx"
              + restart_policy             = (known after apply)
              + stdin                      = false
              + stdin_once                 = false
              + termination_message_path   = "/dev/termination-log"
              + termination_message_policy = (known after apply)
              + tty                        = false

              + resources (known after apply)
            }

          + image_pull_secrets (known after apply)

          + readiness_gate (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ kubectl get pods
No resources found in default namespace.

$ terraform apply tfplan
kubernetes_pod_v1.nginx: Creating...
kubernetes_pod_v1.nginx: Creation complete after 1s [id=default/nginx]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ kubectl get pods nginx
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          22s

$ kubectl get pods --output=json nginx | jq --raw-output .status.podIP
10.1.243.204

$ kubectl get pods --output=yaml nginx | yq .spec.containers[].image
nginx:alpine

$ curl --connect-timeout 5 --fail --show-error --silent 10.1.243.204
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]
```

```bash
$ patch --forward --reject-file=- main.tf <<EOF
19c19
<       image = "nginx:alpine"
---
>       image = "nginx:trixie"
EOF
patching file main.tf

$ cat main.tf | tail --lines=7
  spec {
    container {
      image = "nginx:trixie"
      name  = "nginx"
    }
  }
}

$ terraform fmt -check -diff

$ terraform validate
Success! The configuration is valid.
```

```bash
$ terraform plan -out=tfplan
kubernetes_pod_v1.nginx: Refreshing state... [id=default/nginx]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # kubernetes_pod_v1.nginx must be replaced
-/+ resource "kubernetes_pod_v1" "nginx" {
      ~ id = "default/nginx" -> (known after apply)

      ~ metadata {
          - annotations      = {
              - "cni.projectcalico.org/containerID" = "0cd0aec3336da1fcdd8eb9ea2140c26273279a3d6c2a4
a3f1a4a98bb0f602c59"
              - "cni.projectcalico.org/podIP"       = "10.1.243.204/32"
              - "cni.projectcalico.org/podIPs"      = "10.1.243.204/32"
            } -> null
          ~ generation       = 1 -> (known after apply)
          - labels           = {} -> null
            name             = "nginx"
          ~ resource_version = "12660" -> (known after apply)
          ~ uid              = "764cffeb-e456-486a-a2c4-26241a53ff03" -> (known after apply)
            # (2 unchanged attributes hidden)
        }

      ~ spec {
          - active_deadline_seconds          = 0 -> null
          + hostname                         = (known after apply)
          ~ node_name                        = "ubuntu" -> (known after apply)
          - node_selector                    = {} -> null
          ~ scheduler_name                   = "default-scheduler" -> (known after apply)
          ~ service_account_name             = "default" -> (known after apply)
            # (12 unchanged attributes hidden)

          ~ container {
              - args                       = [] -> null
              - command                    = [] -> null
              ~ image                      = "nginx:alpine" -> "nginx:trixie" # forces replacement
              ~ image_pull_policy          = "IfNotPresent" -> (known after apply)
                name                       = "nginx"
              + restart_policy             = (known after apply)
              ~ termination_message_policy = "File" -> (known after apply)
                # (5 unchanged attributes hidden)

              ~ resources (known after apply)
              - resources {
                  - limits   = {} -> null
                  - requests = {} -> null
                }
            }

          ~ image_pull_secrets (known after apply)

          ~ readiness_gate (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 1 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
kubernetes_pod_v1.nginx: Destroying... [id=default/nginx]
kubernetes_pod_v1.nginx: Destruction complete after 0s
kubernetes_pod_v1.nginx: Creating...
kubernetes_pod_v1.nginx: Creation complete after 7s [id=default/nginx]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

$ kubectl get pods nginx
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          23s

$ kubectl get pods --output=json nginx | jq --raw-output .status.podIP
10.1.243.205

$ kubectl get pods --output=yaml nginx | yq .spec.containers[].image
nginx:trixie

$ curl --connect-timeout 5 --fail --show-error --silent 10.1.243.205
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]
```

```bash
$ terraform destroy -auto-approve
kubernetes_pod_v1.nginx: Refreshing state... [id=default/nginx]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # kubernetes_pod_v1.nginx will be destroyed
  - resource "kubernetes_pod_v1" "nginx" {
      - id = "default/nginx" -> null

      - metadata {
          - annotations      = {
              - "cni.projectcalico.org/containerID" = "052baa189112b6d0e81aff26d3d6d9d995109c487fac7
9c591b27feda6e53551"
              - "cni.projectcalico.org/podIP"       = "10.1.243.205/32"
              - "cni.projectcalico.org/podIPs"      = "10.1.243.205/32"
            } -> null
          - generation       = 1 -> null
          - labels           = {} -> null
          - name             = "nginx" -> null
          - namespace        = "default" -> null
          - resource_version = "13619" -> null
          - uid              = "f38b58bc-33cc-4e61-b352-40ae1be02bf4" -> null
            # (1 unchanged attribute hidden)
        }

      - spec {
          - active_deadline_seconds          = 0 -> null
          - automount_service_account_token  = true -> null
          - dns_policy                       = "ClusterFirst" -> null
          - enable_service_links             = true -> null
          - host_ipc                         = false -> null
          - host_network                     = false -> null
          - host_pid                         = false -> null
          - node_name                        = "ubuntu" -> null
          - node_selector                    = {} -> null
          - restart_policy                   = "Always" -> null
          - scheduler_name                   = "default-scheduler" -> null
          - service_account_name             = "default" -> null
          - share_process_namespace          = false -> null
          - termination_grace_period_seconds = 30 -> null
            # (4 unchanged attributes hidden)

          - container {
              - args                       = [] -> null
              - command                    = [] -> null
              - image                      = "nginx:trixie" -> null
              - image_pull_policy          = "IfNotPresent" -> null
              - name                       = "nginx" -> null
              - stdin                      = false -> null
              - stdin_once                 = false -> null
              - termination_message_path   = "/dev/termination-log" -> null
              - termination_message_policy = "File" -> null
              - tty                        = false -> null
                # (2 unchanged attributes hidden)

              - resources {
                  - limits   = {} -> null
                  - requests = {} -> null
                }
            }
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.
kubernetes_pod_v1.nginx: Destroying... [id=default/nginx]
kubernetes_pod_v1.nginx: Destruction complete after 2s

Destroy complete! Resources: 1 destroyed.

$ kubectl get pods
No resources found in default namespace.

$ rm --verbose main.tf .terraform.lock.hcl tfplan terraform.tfstate terraform.tfstate.backup
removed 'main.tf'
removed '.terraform.lock.hcl'
removed 'tfplan'
removed 'terraform.tfstate'
removed 'terraform.tfstate.backup'

$ rm --recursive .terraform

$ unset KUBE_CONFIG_PATH
```

&nbsp;

`-`

[![Monster](https://avatars.githubusercontent.com/u/47848582?s=96&v=4 "Boo!")](../README.md)
