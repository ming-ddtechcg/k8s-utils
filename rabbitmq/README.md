# RabbitMQ
A message queue system.

The configuration of the deployment is set for three instances of RabbitMQ to simulate the high availability with the quorum requirement. Therefore, the specific configuration is configured in the RabbitMQ plugins while the deployment is occured, they are:

- federation:  to have: 1. message replication, 2. load distribution, 3. cluster migration, and 4. disaster recovery.
- discovery:  to have: 1. automatic clustering, 2. dynamic scaling, and 3. stateful resilience.

The plugins is available at rabbitmq/chat/rabbitmq/config/enabled_plugins.


## directory structure

```
.
├── base-images
│   ├── busybox
│   │   └── 1.38.0
│   │       ├── build.sh
│   │       └── Dockerfile
│   └── rabbitmq
│       ├── 3.13-management
│       │   ├── build.sh
│       │   └── Dockerfile
│       └── 3.8-management
│           ├── build.sh
│           └── Dockerfile
├── rabbitmq
│   ├── chart
│   │   └── rabbitmq
│   │       ├── Chart.yaml
│   │       ├── config
│   │       │   ├── enabled_plugins
│   │       │   └── rabbitmq.conf
│   │       ├── scripts
│   │       │   └── init
│   │       │       └── rabbitmq-config-proc.sh
│   │       ├── templates
│   │       │   ├── configmap.yaml
│   │       │   ├── ingress.yaml
│   │       │   ├── mgmt-service.yaml
│   │       │   ├── NOTES.txt
│   │       │   ├── rolebinding.yaml
│   │       │   ├── role.yaml
│   │       │   ├── script-init-configmap.yaml
│   │       │   ├── secret.yaml
│   │       │   ├── serviceaccount.yaml
│   │       │   ├── service.yaml
│   │       │   └── statefulset.yaml
│   │       └── values.yaml
│   ├── deploy-env
│   │   ├── dev
│   │   │   └── rabbitmq
│   │   │       └── values.yaml
│   │   └── prod
│   │       └── rabbitmq
│   │           └── values.yaml
│   └── utils
│       ├── deploy.sh
│       ├── deploy_ui.sh
│       ├── exec-rabbitmq.sh
│       ├── logs-rabbitmq.sh
│       ├── pod-exec-template.sh
│       └── questionutils.sh
├── rabbitmq-configs
│   ├── enabled_plugins
│   └── rabbitmq.conf
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
rabbitmq deployment
======================================================================
namespace: rabbitmq
chart name: rabbitmq
values file: ../deploy-env/dev/rabbitmq/values.yaml

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

- [RabbitMQ on Kubernetes](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/messaging/rabbitmq/kubernetes)
- [DIY RabbitMQ on Kubernetes](https://github.com/rabbitmq/diy-kubernetes-examples)
