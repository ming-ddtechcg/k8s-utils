# Headlamp

## Installation

```console
$ helm install headlamp headlamp-0.45.0.tgz \
  --namespace kube-system \
  --set image.tag=v0.45.0 \
  --set image.repository=harbor.ddtechcg.com:5001/headlamp-k8s/headlamp
```

## References

- [Using Helm](https://headlamp.dev/docs/latest/installation/in-cluster/#using-helm)
