Kubernetes repository setup for Ubuntu
=======================================

# Define the Kubernetes version 

```
KUBERNETES_VERSION=v1.36
```

# Install the dependencies for adding repositories

```bash
sudo apt-get update
sudo apt-get install -y software-properties-common curl
```

# Add the Kubernetes repository

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --batch --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list
```

# Install the packages

```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
```

# References

- [Kubernetes Packaging](https://github.com/cri-o/packaging/blob/main/README.md#add-the-kubernetes-repository-1)
