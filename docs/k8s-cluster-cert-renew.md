Kubernetes Cluster certifcate check and renew
=============================================

# Check Expiration Status

Login one of master/control-plane nodes and execute the following command:

```bash
sudo kubeadm certs check-expiration
```

# Renew all cerificates

On one of master/control-plane nodes and execute the following command to renew all certifcates:

```bash
sudo kubeadm certs renew all
```

restart the processes of the following:

```
kube-apiserver, kube-controller-manager, kube-scheduler and etcd
```

with the following command:

```bash
for each_process in `ps -ef | egrep "kube-apiserver|kube-controller-manager|kube-scheduler|etcd" | grep -v grep | awk '{ print $2 }'`
do
    if [ "${each_process}" = "" ]
    then
        continue
    fi

    sudo kill -9 ${each_process}
done
```

# Updates for all node Kubelet
To enable kubelet to roate the certificate for two methods:

## method 1 (recommended)
ensure the following lines in /var/lib/kubelet/config.yaml:

```yaml
rotateCertificates: true
serverTLSBootstrap: true
```

## method 2
update /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf for Environment="KUBELET_KUBECONFIG_ARGS=...", likes 

```bash
sudo vi /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
```

for:

```bash
--rotate-certificates=true --rotate-server-certificates=true --bootstrap-kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig --kubeconfig=/var/lib/kubelet/kubeconfig
```

then perform the following commands for the kubelet node that has been updated:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

# Check Pending Certificate Signing Requests (CSRs)
check any pending csrs and approve them:

```bash
kubectl get csr
```

output:

```
NAME        AGE     SIGNERNAME                      REQUESTOR                           REQUESTEDDURATION   CONDITION
csr-hbbhh   12m     kubernetes.io/kubelet-serving   system:node:kubee-wn1-ubuntu-2204   <none>              Pending
csr-kdl2p   89s     kubernetes.io/kubelet-serving   system:node:kubee-mn1-ubuntu-2204   <none>              Pending
csr-m49gj   5m18s   kubernetes.io/kubelet-serving   system:node:kubee-wn1-ubuntu-2204   <none>              Pending
```

# Approve the New Certificate:

```bash
for each_csr in `kubectl get csr --no-headers | awk '{ print $1 }'`
do
    if [ "${each_csr}" = "" ]
    then
        continue
    fi

    kubectl certificate approve ${each_csr}
done
```

