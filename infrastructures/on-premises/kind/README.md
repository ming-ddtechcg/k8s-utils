# kind
kind is a tool for running local Kubernetes clusters using Docker container "nodes". 

## installation

```console
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.33.0/kind-$(uname)-amd64
chmod +x kind && sudo install kind /usr/local/bin/kind
```

## Create a cluster

```console
kind create cluster
```

## Destroy the cluster

```console
kind delete cluster
```

## References

- [kind](https://github.com/kubernetes-sigs/kind)
