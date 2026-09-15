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

