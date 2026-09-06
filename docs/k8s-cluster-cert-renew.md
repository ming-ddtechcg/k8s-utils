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

## method 1
ensure the following lines in /var/lib/kubelet/config.yaml:

```yaml
rotateCertificates: true
serverTLSBootstrap: true
```

## method 2
update /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf for Environment="KUBELET_KUBECONFIG_ARGS=...", likes

```bash
--rotate-server-certificates=true --bootstrap-kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig --kubeconfig=/var/lib/kubelet/kubeconfig
```

then perform:

```bash
systemctl daemon-reload
systemctl restart kubelet
```

