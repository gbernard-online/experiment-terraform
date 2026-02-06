# EXPERIMENT TERRAFORM

## REFERENCES

https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest

https://www.youtube.com/watch?v=onfZmhADZMg&list=PLn6POgpklwWrpWnv05paAdqbFbV6gApHx

## PRACTICE #11 - TERRAFORM - UBUNTU 24

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

resource "kubernetes_manifest" "nginx" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "ReplicaSet"

    metadata = {
      name      = "nginx"
      namespace = "default"

      labels = {
        app = "nginx"
      }
    }
    spec = {
      replicas = 3

      selector = {
        matchLabels = {
          app = "nginx"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "nginx"
          }
        }
        spec = {
          containers = [
            {
              image = "nginx:alpine"
              name  = "nginx"
            }
          ]
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

  # kubernetes_manifest.nginx will be created
  + resource "kubernetes_manifest" "nginx" {
      + manifest = {
          + apiVersion = "apps/v1"
          + kind       = "ReplicaSet"
          + metadata   = {
              + labels    = {
                  + app = "nginx"
                }
              + name      = "nginx"
              + namespace = "default"
            }
          + spec       = {
              + replicas = 3
              + selector = {
                  + matchLabels = {
                      + app = "nginx"
                    }
                }
              + template = {
                  + metadata = {
                      + labels = {
                          + app = "nginx"
                        }
                    }
                  + spec     = {
                      + containers = [
                          + {
                              + image = "nginx:alpine"
                              + name  = "nginx"
                            },
                        ]
                    }
                }
            }
        }
      + object   = {
          + apiVersion = "apps/v1"
          + kind       = "ReplicaSet"
          + metadata   = {
              + annotations                = (known after apply)
              + creationTimestamp          = (known after apply)
              + deletionGracePeriodSeconds = (known after apply)
              + deletionTimestamp          = (known after apply)
              + finalizers                 = (known after apply)
              + generateName               = (known after apply)
              + generation                 = (known after apply)
              + labels                     = (known after apply)
              + managedFields              = (known after apply)
              + name                       = "nginx"
              + namespace                  = "default"
              + ownerReferences            = (known after apply)
              + resourceVersion            = (known after apply)
              + selfLink                   = (known after apply)
              + uid                        = (known after apply)
            }
          + spec       = {
              + minReadySeconds = (known after apply)
              + replicas        = 3
              + selector        = {
                  + matchExpressions = (known after apply)
                  + matchLabels      = {
                      + app = "nginx"
                    }
                }
              + template        = {
                  + metadata = {
                      + annotations                = (known after apply)
                      + creationTimestamp          = (known after apply)
                      + deletionGracePeriodSeconds = (known after apply)
                      + deletionTimestamp          = (known after apply)
                      + finalizers                 = (known after apply)
                      + generateName               = (known after apply)
                      + generation                 = (known after apply)
                      + labels                     = {
                          + app = "nginx"
                        }
                      + managedFields              = (known after apply)
                      + name                       = (known after apply)
                      + namespace                  = (known after apply)
                      + ownerReferences            = (known after apply)
                      + resourceVersion            = (known after apply)
                      + selfLink                   = (known after apply)
                      + uid                        = (known after apply)
                    }
                  + spec     = {
                      + activeDeadlineSeconds         = (known after apply)
                      + affinity                      = {
                          + nodeAffinity    = {
                              + preferredDuringSchedulingIgnoredDuringExecution = (known after apply)
                              + requiredDuringSchedulingIgnoredDuringExecution  = {
                                  + nodeSelectorTerms = (known after apply)
                                }
                            }
                          + podAffinity     = {
                              + preferredDuringSchedulingIgnoredDuringExecution = (known after apply)
                              + requiredDuringSchedulingIgnoredDuringExecution  = (known after apply)
                            }
                          + podAntiAffinity = {
                              + preferredDuringSchedulingIgnoredDuringExecution = (known after apply)
                              + requiredDuringSchedulingIgnoredDuringExecution  = (known after apply)
                            }
                        }
                      + automountServiceAccountToken  = (known after apply)
                      + containers                    = [
                          + {
                              + args                     = (known after apply)
                              + command                  = (known after apply)
                              + env                      = (known after apply)
                              + envFrom                  = (known after apply)
                              + image                    = "nginx:alpine"
                              + imagePullPolicy          = (known after apply)
                              + lifecycle                = {
                                  + postStart  = {
                                      + exec      = {
                                          + command = (known after apply)
                                        }
                                      + httpGet   = {
                                          + host        = (known after apply)
                                          + httpHeaders = (known after apply)
                                          + path        = (known after apply)
                                          + port        = (known after apply)
                                          + scheme      = (known after apply)
                                        }
                                      + sleep     = {
                                          + seconds = (known after apply)
                                        }
                                      + tcpSocket = {
                                          + host = (known after apply)
                                          + port = (known after apply)
                                        }
                                    }
                                  + preStop    = {
                                      + exec      = {
                                          + command = (known after apply)
                                        }
                                      + httpGet   = {
                                          + host        = (known after apply)
                                          + httpHeaders = (known after apply)
                                          + path        = (known after apply)
                                          + port        = (known after apply)
                                          + scheme      = (known after apply)
                                        }
                                      + sleep     = {
                                          + seconds = (known after apply)
                                        }
                                      + tcpSocket = {
                                          + host = (known after apply)
                                          + port = (known after apply)
                                        }
                                    }
                                  + stopSignal = (known after apply)
                                }
                              + livenessProbe            = {
                                  + exec                          = {
                                      + command = (known after apply)
                                    }
                                  + failureThreshold              = (known after apply)
                                  + grpc                          = {
                                      + port    = (known after apply)
                                      + service = (known after apply)
                                    }
                                  + httpGet                       = {
                                      + host        = (known after apply)
                                      + httpHeaders = (known after apply)
                                      + path        = (known after apply)
                                      + port        = (known after apply)
                                      + scheme      = (known after apply)
                                    }
                                  + initialDelaySeconds           = (known after apply)
                                  + periodSeconds                 = (known after apply)
                                  + successThreshold              = (known after apply)
                                  + tcpSocket                     = {
                                      + host = (known after apply)
                                      + port = (known after apply)
                                    }
                                  + terminationGracePeriodSeconds = (known after apply)
                                  + timeoutSeconds                = (known after apply)
                                }
                              + name                     = "nginx"
                              + ports                    = (known after apply)
                              + readinessProbe           = {
                                  + exec                          = {
                                      + command = (known after apply)
                                    }
                                  + failureThreshold              = (known after apply)
                                  + grpc                          = {
                                      + port    = (known after apply)
                                      + service = (known after apply)
                                    }
                                  + httpGet                       = {
                                      + host        = (known after apply)
                                      + httpHeaders = (known after apply)
                                      + path        = (known after apply)
                                      + port        = (known after apply)
                                      + scheme      = (known after apply)
                                    }
                                  + initialDelaySeconds           = (known after apply)
                                  + periodSeconds                 = (known after apply)
                                  + successThreshold              = (known after apply)
                                  + tcpSocket                     = {
                                      + host = (known after apply)
                                      + port = (known after apply)
                                    }
                                  + terminationGracePeriodSeconds = (known after apply)
                                  + timeoutSeconds                = (known after apply)
                                }
                              + resizePolicy             = (known after apply)
                              + resources                = {
                                  + claims   = (known after apply)
                                  + limits   = (known after apply)
                                  + requests = (known after apply)
                                }
                              + restartPolicy            = (known after apply)
                              + restartPolicyRules       = (known after apply)
                              + securityContext          = {
                                  + allowPrivilegeEscalation = (known after apply)
                                  + appArmorProfile          = {
                                      + localhostProfile = (known after apply)
                                      + type             = (known after apply)
                                    }
                                  + capabilities             = {
                                      + add  = (known after apply)
                                      + drop = (known after apply)
                                    }
                                  + privileged               = (known after apply)
                                  + procMount                = (known after apply)
                                  + readOnlyRootFilesystem   = (known after apply)
                                  + runAsGroup               = (known after apply)
                                  + runAsNonRoot             = (known after apply)
                                  + runAsUser                = (known after apply)
                                  + seLinuxOptions           = {
                                      + level = (known after apply)
                                      + role  = (known after apply)
                                      + type  = (known after apply)
                                      + user  = (known after apply)
                                    }
                                  + seccompProfile           = {
                                      + localhostProfile = (known after apply)
                                      + type             = (known after apply)
                                    }
                                  + windowsOptions           = {
                                      + gmsaCredentialSpec     = (known after apply)
                                      + gmsaCredentialSpecName = (known after apply)
                                      + hostProcess            = (known after apply)
                                      + runAsUserName          = (known after apply)
                                    }
                                }
                              + startupProbe             = {
                                  + exec                          = {
                                      + command = (known after apply)
                                    }
                                  + failureThreshold              = (known after apply)
                                  + grpc                          = {
                                      + port    = (known after apply)
                                      + service = (known after apply)
                                    }
                                  + httpGet                       = {
                                      + host        = (known after apply)
                                      + httpHeaders = (known after apply)
                                      + path        = (known after apply)
                                      + port        = (known after apply)
                                      + scheme      = (known after apply)
                                    }
                                  + initialDelaySeconds           = (known after apply)
                                  + periodSeconds                 = (known after apply)
                                  + successThreshold              = (known after apply)
                                  + tcpSocket                     = {
                                      + host = (known after apply)
                                      + port = (known after apply)
                                    }
                                  + terminationGracePeriodSeconds = (known after apply)
                                  + timeoutSeconds                = (known after apply)
                                }
                              + stdin                    = (known after apply)
                              + stdinOnce                = (known after apply)
                              + terminationMessagePath   = (known after apply)
                              + terminationMessagePolicy = (known after apply)
                              + tty                      = (known after apply)
                              + volumeDevices            = (known after apply)
                              + volumeMounts             = (known after apply)
                              + workingDir               = (known after apply)
                            },
                        ]
                      + dnsConfig                     = {
                          + nameservers = (known after apply)
                          + options     = (known after apply)
                          + searches    = (known after apply)
                        }
                      + dnsPolicy                     = (known after apply)
                      + enableServiceLinks            = (known after apply)
                      + ephemeralContainers           = (known after apply)
                      + hostAliases                   = (known after apply)
                      + hostIPC                       = (known after apply)
                      + hostNetwork                   = (known after apply)
                      + hostPID                       = (known after apply)
                      + hostUsers                     = (known after apply)
                      + hostname                      = (known after apply)
                      + hostnameOverride              = (known after apply)
                      + imagePullSecrets              = (known after apply)
                      + initContainers                = (known after apply)
                      + nodeName                      = (known after apply)
                      + nodeSelector                  = (known after apply)
                      + os                            = {
                          + name = (known after apply)
                        }
                      + overhead                      = (known after apply)
                      + preemptionPolicy              = (known after apply)
                      + priority                      = (known after apply)
                      + priorityClassName             = (known after apply)
                      + readinessGates                = (known after apply)
                      + resourceClaims                = (known after apply)
                      + resources                     = {
                          + claims   = (known after apply)
                          + limits   = (known after apply)
                          + requests = (known after apply)
                        }
                      + restartPolicy                 = (known after apply)
                      + runtimeClassName              = (known after apply)
                      + schedulerName                 = (known after apply)
                      + schedulingGates               = (known after apply)
                      + securityContext               = {
                          + appArmorProfile          = {
                              + localhostProfile = (known after apply)
                              + type             = (known after apply)
                            }
                          + fsGroup                  = (known after apply)
                          + fsGroupChangePolicy      = (known after apply)
                          + runAsGroup               = (known after apply)
                          + runAsNonRoot             = (known after apply)
                          + runAsUser                = (known after apply)
                          + seLinuxChangePolicy      = (known after apply)
                          + seLinuxOptions           = {
                              + level = (known after apply)
                              + role  = (known after apply)
                              + type  = (known after apply)
                              + user  = (known after apply)
                            }
                          + seccompProfile           = {
                              + localhostProfile = (known after apply)
                              + type             = (known after apply)
                            }
                          + supplementalGroups       = (known after apply)
                          + supplementalGroupsPolicy = (known after apply)
                          + sysctls                  = (known after apply)
                          + windowsOptions           = {
                              + gmsaCredentialSpec     = (known after apply)
                              + gmsaCredentialSpecName = (known after apply)
                              + hostProcess            = (known after apply)
                              + runAsUserName          = (known after apply)
                            }
                        }
                      + serviceAccount                = (known after apply)
                      + serviceAccountName            = (known after apply)
                      + setHostnameAsFQDN             = (known after apply)
                      + shareProcessNamespace         = (known after apply)
                      + subdomain                     = (known after apply)
                      + terminationGracePeriodSeconds = (known after apply)
                      + tolerations                   = (known after apply)
                      + topologySpreadConstraints     = (known after apply)
                      + volumes                       = (known after apply)
                      + workloadRef                   = {
                          + name               = (known after apply)
                          + podGroup           = (known after apply)
                          + podGroupReplicaKey = (known after apply)
                        }
                    }
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
kubernetes_manifest.nginx: Creating...
kubernetes_manifest.nginx: Creation complete after 0s

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

$ kubectl get replicasets.apps nginx
NAME    DESIRED   CURRENT   READY   AGE
nginx   3         3         3       22s

$ kubectl get pods --selector=app=nginx
NAME          READY   STATUS    RESTARTS   AGE
nginx-k4clq   1/1     Running   0          34s
nginx-nl4xn   1/1     Running   0          34s
nginx-qwjvb   1/1     Running   0          34s

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
24c24
<       replicas = 3
---
>       replicas = 9
EOF
patching file main.tf

$ terraform fmt -check -diff

$ terraform validate
Success! The configuration is valid.

$ terraform plan -out=tfplan
kubernetes_manifest.nginx: Refreshing state...

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # kubernetes_manifest.nginx will be updated in-place
  ~ resource "kubernetes_manifest" "nginx" {
      ~ manifest = {
          ~ spec       = {
              ~ replicas = 3 -> 9
                # (2 unchanged attributes hidden)
            }
            # (3 unchanged attributes hidden)
        }
      ~ object   = {
          ~ spec       = {
              ~ replicas        = 3 -> 9
                # (3 unchanged attributes hidden)
            }
            # (3 unchanged attributes hidden)
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

$ terraform apply tfplan
kubernetes_manifest.nginx: Modifying...
kubernetes_manifest.nginx: Modifications complete after 0s

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

$ kubectl get replicasets.apps nginx
NAME    DESIRED   CURRENT   READY   AGE
nginx   9         9         9       86s

$ kubectl get pods --selector=app=nginx
NAME          READY   STATUS    RESTARTS   AGE
nginx-22b5s   1/1     Running   0          24s
nginx-8hlgj   1/1     Running   0          24s
nginx-k4clq   1/1     Running   0          109s
nginx-m7cdw   1/1     Running   0          24s
nginx-n6wmb   1/1     Running   0          24s
nginx-nl4xn   1/1     Running   0          109s
nginx-qwjvb   1/1     Running   0          109s
nginx-xghwd   1/1     Running   0          24s
nginx-z4vjn   1/1     Running   0          24s

$ kubectl get pods --output=yaml --selector=app=nginx | yq .items[].spec.nodeName
cluster-worker-green
cluster-worker-yellow
cluster-worker-yellow
cluster-worker-green
cluster-worker-red
cluster-worker-red
cluster-worker-green
cluster-worker-red
cluster-worker-yellow
```

```bash
$ terraform destroy -auto-approve
kubernetes_manifest.nginx: Refreshing state...

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # kubernetes_manifest.nginx will be destroyed
  - resource "kubernetes_manifest" "nginx" {
      - manifest = {
          - apiVersion = "apps/v1"
          - kind       = "ReplicaSet"
          - metadata   = {
              - labels    = {
                  - app = "nginx"
                }
              - name      = "nginx"
              - namespace = "default"
            }
          - spec       = {
              - replicas = 9
              - selector = {
                  - matchLabels = {
                      - app = "nginx"
                    }
                }
              - template = {
                  - metadata = {
                      - labels = {
                          - app = "nginx"
                        }
                    }
                  - spec     = {
                      - containers = [
                          - {
                              - image = "nginx:alpine"
                              - name  = "nginx"
                            },
                        ]
                    }
                }
            }
        } -> null
      - object   = {
          - apiVersion = "apps/v1"
          - kind       = "ReplicaSet"
          - metadata   = {
              - annotations                = null
              - creationTimestamp          = null
              - deletionGracePeriodSeconds = null
              - deletionTimestamp          = null
              - finalizers                 = null
              - generateName               = null
              - generation                 = null
              - labels                     = {
                  - app = "nginx"
                }
              - managedFields              = null
              - name                       = "nginx"
              - namespace                  = "default"
              - ownerReferences            = null
              - resourceVersion            = null
              - selfLink                   = null
              - uid                        = null
            }
          - spec       = {
              - minReadySeconds = null
              - replicas        = 9
              - selector        = {
                  - matchExpressions = null
                  - matchLabels      = {
                      - app = "nginx"
                    }
                }
              - template        = {
                  - metadata = {
                      - annotations                = null
                      - creationTimestamp          = null
                      - deletionGracePeriodSeconds = null
                      - deletionTimestamp          = null
                      - finalizers                 = null
                      - generateName               = null
                      - generation                 = null
                      - labels                     = {
                          - app = "nginx"
                        }
                      - managedFields              = null
                      - name                       = null
                      - namespace                  = null
                      - ownerReferences            = null
                      - resourceVersion            = null
                      - selfLink                   = null
                      - uid                        = null
                    }
                  - spec     = {
                      - activeDeadlineSeconds         = null
                      - affinity                      = {
                          - nodeAffinity    = {
                              - preferredDuringSchedulingIgnoredDuringExecution = null
                              - requiredDuringSchedulingIgnoredDuringExecution  = {
                                  - nodeSelectorTerms = null
                                }
                            }
                          - podAffinity     = {
                              - preferredDuringSchedulingIgnoredDuringExecution = null
                              - requiredDuringSchedulingIgnoredDuringExecution  = null
                            }
                          - podAntiAffinity = {
                              - preferredDuringSchedulingIgnoredDuringExecution = null
                              - requiredDuringSchedulingIgnoredDuringExecution  = null
                            }
                        }
                      - automountServiceAccountToken  = null
                      - containers                    = [
                          - {
                              - args                     = null
                              - command                  = null
                              - env                      = null
                              - envFrom                  = null
                              - image                    = "nginx:alpine"
                              - imagePullPolicy          = "IfNotPresent"
                              - lifecycle                = {
                                  - postStart  = {
                                      - exec      = {
                                          - command = null
                                        }
                                      - httpGet   = {
                                          - host        = null
                                          - httpHeaders = null
                                          - path        = null
                                          - port        = null
                                          - scheme      = null
                                        }
                                      - sleep     = {
                                          - seconds = null
                                        }
                                      - tcpSocket = {
                                          - host = null
                                          - port = null
                                        }
                                    }
                                  - preStop    = {
                                      - exec      = {
                                          - command = null
                                        }
                                      - httpGet   = {
                                          - host        = null
                                          - httpHeaders = null
                                          - path        = null
                                          - port        = null
                                          - scheme      = null
                                        }
                                      - sleep     = {
                                          - seconds = null
                                        }
                                      - tcpSocket = {
                                          - host = null
                                          - port = null
                                        }
                                    }
                                  - stopSignal = null
                                }
                              - livenessProbe            = {
                                  - exec                          = {
                                      - command = null
                                    }
                                  - failureThreshold              = null
                                  - grpc                          = {
                                      - port    = null
                                      - service = null
                                    }
                                  - httpGet                       = {
                                      - host        = null
                                      - httpHeaders = null
                                      - path        = null
                                      - port        = null
                                      - scheme      = null
                                    }
                                  - initialDelaySeconds           = null
                                  - periodSeconds                 = null
                                  - successThreshold              = null
                                  - tcpSocket                     = {
                                      - host = null
                                      - port = null
                                    }
                                  - terminationGracePeriodSeconds = null
                                  - timeoutSeconds                = null
                                }
                              - name                     = "nginx"
                              - ports                    = null
                              - readinessProbe           = {
                                  - exec                          = {
                                      - command = null
                                    }
                                  - failureThreshold              = null
                                  - grpc                          = {
                                      - port    = null
                                      - service = null
                                    }
                                  - httpGet                       = {
                                      - host        = null
                                      - httpHeaders = null
                                      - path        = null
                                      - port        = null
                                      - scheme      = null
                                    }
                                  - initialDelaySeconds           = null
                                  - periodSeconds                 = null
                                  - successThreshold              = null
                                  - tcpSocket                     = {
                                      - host = null
                                      - port = null
                                    }
                                  - terminationGracePeriodSeconds = null
                                  - timeoutSeconds                = null
                                }
                              - resizePolicy             = null
                              - resources                = {
                                  - claims   = null
                                  - limits   = null
                                  - requests = null
                                }
                              - restartPolicy            = null
                              - restartPolicyRules       = null
                              - securityContext          = {
                                  - allowPrivilegeEscalation = null
                                  - appArmorProfile          = {
                                      - localhostProfile = null
                                      - type             = null
                                    }
                                  - capabilities             = {
                                      - add  = null
                                      - drop = null
                                    }
                                  - privileged               = null
                                  - procMount                = null
                                  - readOnlyRootFilesystem   = null
                                  - runAsGroup               = null
                                  - runAsNonRoot             = null
                                  - runAsUser                = null
                                  - seLinuxOptions           = {
                                      - level = null
                                      - role  = null
                                      - type  = null
                                      - user  = null
                                    }
                                  - seccompProfile           = {
                                      - localhostProfile = null
                                      - type             = null
                                    }
                                  - windowsOptions           = {
                                      - gmsaCredentialSpec     = null
                                      - gmsaCredentialSpecName = null
                                      - hostProcess            = null
                                      - runAsUserName          = null
                                    }
                                }
                              - startupProbe             = {
                                  - exec                          = {
                                      - command = null
                                    }
                                  - failureThreshold              = null
                                  - grpc                          = {
                                      - port    = null
                                      - service = null
                                    }
                                  - httpGet                       = {
                                      - host        = null
                                      - httpHeaders = null
                                      - path        = null
                                      - port        = null
                                      - scheme      = null
                                    }
                                  - initialDelaySeconds           = null
                                  - periodSeconds                 = null
                                  - successThreshold              = null
                                  - tcpSocket                     = {
                                      - host = null
                                      - port = null
                                    }
                                  - terminationGracePeriodSeconds = null
                                  - timeoutSeconds                = null
                                }
                              - stdin                    = null
                              - stdinOnce                = null
                              - terminationMessagePath   = "/dev/termination-log"
                              - terminationMessagePolicy = "File"
                              - tty                      = null
                              - volumeDevices            = null
                              - volumeMounts             = null
                              - workingDir               = null
                            },
                        ]
                      - dnsConfig                     = {
                          - nameservers = null
                          - options     = null
                          - searches    = null
                        }
                      - dnsPolicy                     = "ClusterFirst"
                      - enableServiceLinks            = null
                      - ephemeralContainers           = null
                      - hostAliases                   = null
                      - hostIPC                       = null
                      - hostNetwork                   = null
                      - hostPID                       = null
                      - hostUsers                     = null
                      - hostname                      = null
                      - hostnameOverride              = null
                      - imagePullSecrets              = null
                      - initContainers                = null
                      - nodeName                      = null
                      - nodeSelector                  = null
                      - os                            = {
                          - name = null
                        }
                      - overhead                      = null
                      - preemptionPolicy              = null
                      - priority                      = null
                      - priorityClassName             = null
                      - readinessGates                = null
                      - resourceClaims                = null
                      - resources                     = {
                          - claims   = null
                          - limits   = null
                          - requests = null
                        }
                      - restartPolicy                 = "Always"
                      - runtimeClassName              = null
                      - schedulerName                 = "default-scheduler"
                      - schedulingGates               = null
                      - securityContext               = {
                          - appArmorProfile          = {
                              - localhostProfile = null
                              - type             = null
                            }
                          - fsGroup                  = null
                          - fsGroupChangePolicy      = null
                          - runAsGroup               = null
                          - runAsNonRoot             = null
                          - runAsUser                = null
                          - seLinuxChangePolicy      = null
                          - seLinuxOptions           = {
                              - level = null
                              - role  = null
                              - type  = null
                              - user  = null
                            }
                          - seccompProfile           = {
                              - localhostProfile = null
                              - type             = null
                            }
                          - supplementalGroups       = null
                          - supplementalGroupsPolicy = null
                          - sysctls                  = null
                          - windowsOptions           = {
                              - gmsaCredentialSpec     = null
                              - gmsaCredentialSpecName = null
                              - hostProcess            = null
                              - runAsUserName          = null
                            }
                        }
                      - serviceAccount                = null
                      - serviceAccountName            = null
                      - setHostnameAsFQDN             = null
                      - shareProcessNamespace         = null
                      - subdomain                     = null
                      - terminationGracePeriodSeconds = 30
                      - tolerations                   = null
                      - topologySpreadConstraints     = null
                      - volumes                       = null
                      - workloadRef                   = {
                          - name               = null
                          - podGroup           = null
                          - podGroupReplicaKey = null
                        }
                    }
                }
            }
        } -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.
kubernetes_manifest.nginx: Destroying...
kubernetes_manifest.nginx: Destruction complete after 0s

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
