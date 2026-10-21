# kind cluster with multi nodes

To create more worker nodes in the kind cluster, the following is example to create an additional worker:

``` console
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
```

save it in a file, called kind-config.yaml

To create a cluster:

```console
kind create cluster --config kind-config.yaml
```

, and result:


```console
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   44s   v1.37.0
kind-worker          Ready    <none>          18s   v1.37.0
```


