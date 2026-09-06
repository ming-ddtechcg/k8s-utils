Kubernetes Cluster certifcate check and renew
=============================================

# Check Expiration Status

Login one of master/control-plane nodes and execute the following command:

```bash
sudo kubeadm certs check-expiration
```

# renew all cerificates

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

    kill -9 ${each_process}
done
```

