# Project Plan — retrieve-cluster-info

> This document reflects the final, as-built result of the project. It supersedes
> the original hand-written plan at [`docs/claude_plan_v1.txt`](docs/claude_plan_v1.txt)
> (updated version: [`docs/claude_plan_v2.txt`](docs/claude_plan_v2.txt)).

## Overview

`fetch-cluster-info` is a small Go CLI that reads the `kubeadm-config` ConfigMap
in the `kube-system` namespace and prints selected values from its embedded
`ClusterConfiguration.networking` section. It runs both as a standalone binary
against any cluster reachable via `KUBECONFIG`, and as a container inside a
cluster, running under a dedicated ServiceAccount with least-privilege RBAC.

## Purpose

Read `kube-system/kubeadm-config`, parse the `data.ClusterConfiguration` YAML
blob, and expose the following fields under `networking`:

- `dnsDomain`
- `podSubnet`
- `serviceSubnet`

## CLI Parameters

| Flag                | Effect                                  |
|----------------------|------------------------------------------|
| `--dns-domain`       | print `dnsDomain`                        |
| `--pod-subnet`       | print `podSubnet`                        |
| `--service-subnet`   | print `serviceSubnet`                    |

If no flags are given, all three values are printed (default behavior).
Output format: `key=value`, one per line (e.g. `dnsDomain=cluster.local`).

## Runtime Environment

The binary supports two modes, chosen automatically:

1. **Outside the cluster** — if the `KUBECONFIG` environment variable is set,
   the client config is built from that kubeconfig file.
2. **Inside the cluster** — otherwise, falls back to `rest.InClusterConfig()`,
   using the pod's mounted ServiceAccount token and CA cert under
   `/run/secrets/kubernetes.io/serviceaccount`.

The binary is built `CGO_ENABLED=0` for a static, libc-independent executable,
so the same artifact runs unmodified on both Alpine (musl) and
Ubuntu/Debian (glibc) base images.

## Project Layout

```
retrieve-cluster-info/
├── main.go                        # CLI entrypoint and ConfigMap parsing logic
├── go.mod / go.sum                # module fetch-cluster-info; go 1.27.1
├── Makefile                       # prepare / build / clean targets
├── docker/
│   ├── Dockerfile                 # FROM harbor.ddtechcg.com/playground/alpine-kubectl:1.36.4
│   └── build.sh                   # copies bin, builds + tags the image
├── k8s-resources/
│   ├── 00-namespace.yaml          # namespace: fetch-cluster-info
│   ├── 01-serviceaccount.yaml     # ServiceAccount: fetch-cluster-info-pod
│   ├── 05-pod.yaml                # debug/exec pod running the image
│   ├── 06-clusterrole.yaml        # get/list on configmap "kubeadm-config" only
│   └── 07-clusterrolebinding.yaml # binds the ClusterRole to the ServiceAccount
└── docs/
    ├── claude_plan_v1.txt         # original hand-written plan
    └── claude_plan_v2.txt         # updated plan, reflecting final result
```

## Build

`make` runs two targets in sequence:

- `prepare` — `go mod tidy`
- `build` — `CGO_ENABLED=0 GOOS=linux go build -o bin/fetch-cluster-info .`

`make clean` removes the `bin/` output directory.

## Container Image

`docker/Dockerfile` copies the compiled `fetch-cluster-info` binary into
`harbor.ddtechcg.com/playground/alpine-kubectl:1.36.4`. `docker/build.sh <tag>`
copies the freshly built binary from `../bin`, builds, and tags the image as
`harbor.ddtechcg.com/playground/fetch-cluster-info:<tag>`.

## In-Cluster Deployment

Applying `k8s-resources/` in order creates:

- Namespace `fetch-cluster-info`
- ServiceAccount `fetch-cluster-info-pod` (same namespace)
- ClusterRole `fetch-cluster-info-pod`, scoped via `resourceNames` to `get`/`list`
  on the single ConfigMap `kubeadm-config` (no broader configmap access)
- ClusterRoleBinding tying the ServiceAccount to that ClusterRole
- A long-running Pod (`sh -c "while true; do sleep 1d; done"`) using the image,
  intended for `kubectl exec` invocation of the binary rather than a one-shot Job

## Status

Implementation complete and verified to build (`go build`) against the pinned
module versions in `go.mod`/`go.sum`. Not yet committed to the `k8s-utils`
git repository.
