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

