# Ingress - nginx controller
Ingress nginx controller is the load balancer runs inside the Kubernetes environment to route HTTP/HTTPS traffic from the external to the internal services.


## directory structure

```
.
├── base-images
│   ├── default-http-backend
│   │   └── 1.5
│   │       ├── build.sh
│   │       └── Dockerfile
│   ├── ingress-nginx
│   │   └── v1.11.2
│   │       ├── build.sh
│   │       └── Dockerfile
│   └── kube-webhook-certgen
│       └── v1.4.3
│           ├── build.sh
│           └── Dockerfile
├── ingress-nginx
│   ├── chart
│   │   └── ingress-nginx
│   │       ├── Chart.yaml
│   │       ├── templates
│   │       │   ├── admission-clusterrolebinding.yaml
│   │       │   ├── admission-clusterrole.yaml
│   │       │   ├── admission-create-job.yaml
│   │       │   ├── admission-patch-job.yaml
│   │       │   ├── admission-rolebinding.yaml
│   │       │   ├── admission-role.yaml
│   │       │   ├── admission-serviceaccount.yaml
│   │       │   ├── admission-service.yaml
│   │       │   ├── clusterrolebinding.yaml
│   │       │   ├── clusterrole.yaml
│   │       │   ├── configmap.yaml
│   │       │   ├── daemonset.yaml
│   │       │   ├── default-http-backend-deployment.yaml
│   │       │   ├── default-http-backend-service.yaml
│   │       │   ├── ingressclass.yaml
│   │       │   ├── namespace.yaml
│   │       │   ├── NOTES.txt
│   │       │   ├── rolebinding.yaml
│   │       │   ├── role.yaml
│   │       │   ├── serviceaccount.yaml
│   │       │   ├── service.yaml
│   │       │   └── validatingwebhookconfiguration.yaml
│   │       └── values.yaml
│   ├── deploy-env
│   │   ├── dev
│   │   │   └── ingress-nginx
│   │   │       └── values.yaml
│   │   └── prod
│   │       └── ingress-nginx
│   │           └── values.yaml
│   └── utils
│       ├── deploy.sh
│       ├── deploy_ui.sh
│       ├── exec-ingress-nginx.sh
│       ├── logs-ingress-nginx.sh
│       ├── pod-exec-template.sh
│       └── questionutils.sh
└── README.md
```

Note:
| directory name | comment |
| --- | --- |
| base-images | The process is to build the package required container image. |
| <package name>/chart | The kubernetes resources with the Helm chart manifest files. |
| deploy-env | The Helm chart deployment value.yaml for dev (development) and prod (production) configurations. |
| utils | all utility files are the deployment and the troubleshot. |

## Build and Deployment

There are two scripts for the Helm chart build and deployment. They are:
- deploy.sh - the deployment command line.
- deploy_ui.sh - the deployment text based UI and a wrapper of deploy.sh.

The following is an example of the execution from deploy_ui.sh:
- namespace: the namespace is where the Helm chart will be deployed to. (**NOTE:** this deployment has its own resource namespace "ingress-nginx", please see value.yaml)
- value file:  the value.yaml is selected from the dev environment.
- chart name:  the name will be filled based on the section from yaml.yaml.

```
ingress-nginx deployment
======================================================================
namespace: kube-system
chart name: ingress-nginx
values file: ../deploy-env/dev/ingress-nginx/values.yaml

options
1.  namespace
2.  select values file
3.  edit values file
4.  generate template YAML
5.  debugging installation
6.  install
7.  uninstall
8.  package

18. shell environment
19. loop this menu for refreshing screen
20. exit

enter selection:
```

## References

- [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
