# EXPERIMENT TERRAFORM

## REFERENCES

https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1

https://www.youtube.com/watch?v=onfZmhADZMg&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #12 - TERRAFORM - UBUNTU 24

[![Terraform](img/terraform.webp "Terraform")](https://developer.hashicorp.com/terraform)1
[![Ubuntu](img/ubuntu.webp "Ubuntu")](https://ubuntu.com)24
[![Kubernetes](img/kubernetes.webp "Kubernetes")](https://kubernetes.io)1
[![Kind](img/kind.webp "Kind")](https://kind.sigs.k8s.io)0

```bash
$ export KUBE_CONFIG_PATH=$HOME/.kube/config

$ cat >main.tf <<EOF
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {}

resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:alpine"
          name  = "nginx"
        }
      }
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

  # kubernetes_deployment_v1.nginx will be created
  + resource "kubernetes_deployment_v1" "nginx" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "app" = "nginx"
            }
          + name             = "nginx"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "3"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "nginx"
                }
            }

          + strategy (known after apply)

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app" = "nginx"
                    }
                  + name             = (known after apply)
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
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
kubernetes_deployment_v1.nginx: Creating...
kubernetes_deployment_v1.nginx: Creation complete after 2s [id=default/nginx]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ kubectl get deployments.apps nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   3/3     3            3           13s

$ kubectl get pods --selector=app=nginx
NAME                    READY   STATUS    RESTARTS   AGE
nginx-bbd87c9cd-jfqzd   1/1     Running   0          20s
nginx-bbd87c9cd-pvchx   1/1     Running   0          20s
nginx-bbd87c9cd-vdlrc   1/1     Running   0          20s

$ kubectl get pods --output=yaml --selector=app=nginx | yq .items[].spec.nodeName
cluster-worker-yellow
cluster-worker-red
cluster-worker-green

$ kubectl get pods --output=json | jq --raw-output .items[].status.podIP
10.244.3.2
10.244.2.2
10.244.1.2

$ docker exec cluster-control-plane \
curl --connect-timeout 5 --fail --show-error --silent 10.244.3.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]

$ docker exec cluster-control-plane \
curl --connect-timeout 5 --fail --show-error --silent 10.244.2.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]

$ docker exec cluster-control-plane \
curl --connect-timeout 5 --fail --show-error --silent 10.244.1.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]
```

```bash
$ patch --forward --reject-file=- main.tf <<EOF
20c20
<     replicas = 3
---
>     replicas = 9
EOF
patching file main.tf

$ terraform fmt -check -diff

$ terraform validate
Success! The configuration is valid.

$ terraform plan -out=tfplan
kubernetes_deployment_v1.nginx: Refreshing state... [id=default/nginx]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # kubernetes_deployment_v1.nginx will be updated in-place
  ~ resource "kubernetes_deployment_v1" "nginx" {
        id               = "default/nginx"
        # (1 unchanged attribute hidden)

      ~ spec {
          ~ replicas                  = "3" -> "9"
            # (4 unchanged attributes hidden)

            # (3 unchanged blocks hidden)
        }

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
kubernetes_deployment_v1.nginx: Modifying... [id=default/nginx]
kubernetes_deployment_v1.nginx: Modifications complete after 3s [id=default/nginx]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

$ kubectl get deployments.apps nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   9/9     9            9           78s

$ kubectl get pods --selector=app=nginx
NAME                    READY   STATUS    RESTARTS   AGE
nginx-bbd87c9cd-7zdw4   1/1     Running   0          18s
nginx-bbd87c9cd-h6h77   1/1     Running   0          18s
nginx-bbd87c9cd-jfqzd   1/1     Running   0          90s
nginx-bbd87c9cd-jvdg7   1/1     Running   0          18s
nginx-bbd87c9cd-pvchx   1/1     Running   0          90s
nginx-bbd87c9cd-vdlrc   1/1     Running   0          90s
nginx-bbd87c9cd-wg466   1/1     Running   0          18s
nginx-bbd87c9cd-wz974   1/1     Running   0          18s
nginx-bbd87c9cd-z4tj4   1/1     Running   0          18s

$ kubectl get pods --output=yaml --selector=app=nginx | yq .items[].spec.nodeName
cluster-worker-yellow
cluster-worker-green
cluster-worker-yellow
cluster-worker-green
cluster-worker-red
cluster-worker-green
cluster-worker-yellow
cluster-worker-red
cluster-worker-red
```

```bash
$ terraform destroy -auto-approve
kubernetes_deployment_v1.nginx: Refreshing state... [id=default/nginx]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # kubernetes_deployment_v1.nginx will be destroyed
  - resource "kubernetes_deployment_v1" "nginx" {
      - id               = "default/nginx" -> null
      - wait_for_rollout = true -> null

      - metadata {
          - annotations      = {} -> null
          - generation       = 2 -> null
          - labels           = {
              - "app" = "nginx"
            } -> null
          - name             = "nginx" -> null
          - namespace        = "default" -> null
          - resource_version = "18789" -> null
          - uid              = "16ce2489-fbe5-4251-8700-7c48194e019f" -> null
            # (1 unchanged attribute hidden)
        }

      - spec {
          - min_ready_seconds         = 0 -> null
          - paused                    = false -> null
          - progress_deadline_seconds = 600 -> null
          - replicas                  = "9" -> null
          - revision_history_limit    = 10 -> null

          - selector {
              - match_labels = {
                  - "app" = "nginx"
                } -> null
            }

          - strategy {
              - type = "RollingUpdate" -> null

              - rolling_update {
                  - max_surge       = "25%" -> null
                  - max_unavailable = "25%" -> null
                }
            }

          - template {
              - metadata {
                  - annotations      = {} -> null
                  - generation       = 0 -> null
                  - labels           = {
                      - "app" = "nginx"
                    } -> null
                    name             = null
                    # (4 unchanged attributes hidden)
                }
              - spec {
                  - active_deadline_seconds          = 0 -> null
                  - automount_service_account_token  = true -> null
                  - dns_policy                       = "ClusterFirst" -> null
                  - enable_service_links             = true -> null
                  - host_ipc                         = false -> null
                  - host_network                     = false -> null
                  - host_pid                         = false -> null
                  - node_selector                    = {} -> null
                  - restart_policy                   = "Always" -> null
                  - scheduler_name                   = "default-scheduler" -> null
                  - share_process_namespace          = false -> null
                  - termination_grace_period_seconds = 30 -> null
                    # (6 unchanged attributes hidden)

                  - container {
                      - args                       = [] -> null
                      - command                    = [] -> null
                      - image                      = "nginx:alpine" -> null
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
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.
kubernetes_deployment_v1.nginx: Destroying... [id=default/nginx]
kubernetes_deployment_v1.nginx: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.

$ kubectl get pods --selector=app=nginx
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
