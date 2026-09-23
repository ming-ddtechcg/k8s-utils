# metrics-server
Metrics Server is to collect metrics from all nodes' kubelet cAdvisor, and exposes the data via the Metrics API (metrics.k8s.io) using the Kubernetes API aggregation layer.

## directory structure

```
.
├── base-images
│   └── v0.6.2
│       ├── build.sh
│       └── Dockerfile
├── metrics-server
│   ├── chart
│   │   └── metrics-server
│   │       ├── Chart.yaml
│   │       ├── templates
│   │       │   ├── aggregated-metrics-reader-clusterrole.yaml
│   │       │   ├── apiservice.yaml
│   │       │   ├── auth-reader-rolebinding.yaml
│   │       │   ├── clusterrolebinding.yaml
│   │       │   ├── clusterrole.yaml
│   │       │   ├── deployment.yaml
│   │       │   ├── NOTES.txt
│   │       │   ├── serviceaccount.yaml
│   │       │   ├── service.yaml
│   │       │   └── system-auth-delegator-clusterrolebinding.yaml
│   │       └── values.yaml
│   ├── deploy-env
│   │   ├── dev
│   │   │   └── metrics-server
│   │   │       └── values.yaml
│   │   └── prod
│   │       └── metrics-server
│   │           └── values.yaml
│   └── utils
│       ├── deploy.sh
│       ├── deploy_ui.sh
│       ├── logs-metrics-server.sh
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
- namespace: the namespace is where the Helm chart will be deployed to.
- value file:  the value.yaml is selected from the dev environment.
- chart name:  the name will be filled based on the section from yaml.yaml.

```
metrics-server deployment
======================================================================
namespace: kube-system
chart name: metrics-server
values file: ../deploy-env/dev/metrics-server/values.yaml

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

- [Metrics Server](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/#metrics-server)
