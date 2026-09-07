# NFS Subdirectory External Provisioner
NFS external provisioner

# Installation

```bash
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner-4.0.18.tgz \
    -n <namespace> \
    --set image.repository=harbor.ddtechcg.com/sig-storage/nfs-subdir-external-provisioner \
    --set image.tag=v4.0.2 \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path \
    --set nfs.reclaimPolicy=Delete \
    --set storageClass.name=nfs-client 
```

nfs.reclaimPolicy can be one in the following value:

```
Retain|Delete|Recycle
```

example:

```bash
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner-4.0.18.tgz \
    -n kube-system \
    --set image.repository=harbor.ddtechcg.com/sig-storage/nfs-subdir-external-provisioner \
    --set image.tag=v4.0.2 \
    --set nfs.server=192.168.20.11 \
    --set nfs.path=/export/share/nfs/k8s/test/ubuntu-2204 \
    --set nfs.reclaimPolicy=Delete \
    --set storageClass.name=nfs-client
```

# References

- [NFS Subdirectory External Provisioner Helm Chart](https://artifacthub.io/packages/helm/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner)

