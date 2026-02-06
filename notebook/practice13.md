# EXPERIMENT TERRAFORM

## REFERENCES

https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/api_service_v1

https://www.youtube.com/watch?v=d6Ee9RYJnbA&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #13 - TERRAFORM - UBUNTU 24

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

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      app = "nginx"
    }
  }
  spec {
    port {
      name        = "8080-80"
      port        = 8080
      target_port = 80
    }
    selector = {
      app = "nginx"
    }
  }
}
EOF

$ terraform fmt -check -diff

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

  # kubernetes_service_v1.nginx will be created
  + resource "kubernetes_service_v1" "nginx" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

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
          + allocate_load_balancer_node_ports = true
          + cluster_ip                        = (known after apply)
          + cluster_ips                       = (known after apply)
          + external_traffic_policy           = (known after apply)
          + health_check_node_port            = (known after apply)
          + internal_traffic_policy           = (known after apply)
          + ip_families                       = (known after apply)
          + ip_family_policy                  = (known after apply)
          + publish_not_ready_addresses       = false
          + selector                          = {
              + "app" = "nginx"
            }
          + session_affinity                  = "None"
          + type                              = "ClusterIP"

          + port {
              + name        = "8080-80"
              + node_port   = (known after apply)
              + port        = 8080
              + protocol    = "TCP"
              + target_port = "80"
            }

          + session_affinity_config (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
kubernetes_service_v1.nginx: Creating...
kubernetes_deployment_v1.nginx: Creating...
kubernetes_service_v1.nginx: Creation complete after 0s [id=default/nginx]
kubernetes_deployment_v1.nginx: Creation complete after 1s [id=default/nginx]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

$ kubectl get services nginx --output=wide
NAME    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE   SELECTOR
nginx   ClusterIP   10.96.44.132   <none>        8080/TCP   30s   app=nginx

$ docker exec cluster-control-plane \
curl --connect-timeout 5 --fail --show-error --silent 10.96.44.132:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
[...]
```

```bash
 terraform destroy -auto-approve
kubernetes_service_v1.nginx: Refreshing state... [id=default/nginx]
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
          - generation       = 1 -> null
          - labels           = {
              - "app" = "nginx"
            } -> null
          - name             = "nginx" -> null
          - namespace        = "default" -> null
          - resource_version = "23679" -> null
          - uid              = "e0e73245-6161-4f02-bc4c-21fc8f9de0bf" -> null
            # (1 unchanged attribute hidden)
        }

      - spec {
          - min_ready_seconds         = 0 -> null
          - paused                    = false -> null
          - progress_deadline_seconds = 600 -> null
          - replicas                  = "3" -> null
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

  # kubernetes_service_v1.nginx will be destroyed
  - resource "kubernetes_service_v1" "nginx" {
      - id                     = "default/nginx" -> null
      - status                 = [
          - {
              - load_balancer = [
                  - {
                      - ingress = []
                    },
                ]
            },
        ] -> null
      - wait_for_load_balancer = true -> null

      - metadata {
          - annotations      = {} -> null
          - generation       = 0 -> null
          - labels           = {
              - "app" = "nginx"
            } -> null
          - name             = "nginx" -> null
          - namespace        = "default" -> null
          - resource_version = "23633" -> null
          - uid              = "d11cb6e5-da1c-4e0f-a3bc-de6ff47e4567" -> null
            # (1 unchanged attribute hidden)
        }

      - spec {
          - allocate_load_balancer_node_ports = true -> null
          - cluster_ip                        = "10.96.44.132" -> null
          - cluster_ips                       = [
              - "10.96.44.132",
            ] -> null
          - external_ips                      = [] -> null
          - health_check_node_port            = 0 -> null
          - internal_traffic_policy           = "Cluster" -> null
          - ip_families                       = [
              - "IPv4",
            ] -> null
          - ip_family_policy                  = "SingleStack" -> null
          - load_balancer_source_ranges       = [] -> null
          - publish_not_ready_addresses       = false -> null
          - selector                          = {
              - "app" = "nginx"
            } -> null
          - session_affinity                  = "None" -> null
          - type                              = "ClusterIP" -> null
            # (4 unchanged attributes hidden)

          - port {
              - name         = "8080-80" -> null
              - node_port    = 0 -> null
              - port         = 8080 -> null
              - protocol     = "TCP" -> null
              - target_port  = "80" -> null
                # (1 unchanged attribute hidden)
            }
        }
    }

Plan: 0 to add, 0 to change, 2 to destroy.
kubernetes_service_v1.nginx: Destroying... [id=default/nginx]
kubernetes_deployment_v1.nginx: Destroying... [id=default/nginx]
kubernetes_deployment_v1.nginx: Destruction complete after 0s
kubernetes_service_v1.nginx: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.

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
