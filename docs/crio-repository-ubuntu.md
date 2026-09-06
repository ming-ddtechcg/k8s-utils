CRI-O repository setup for Ubuntu
=================================

# Define the cri-o version 

```
CRIO_VERSION=v1.36
```

# Install the dependencies for adding repositories

```bash
sudo apt-get update
sudo apt-get install -y software-properties-common curl
```

# Add the CRI-O repository

```bash
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --batch --yes --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list
```

# Install the packages

```bash
sudo apt-get update
sudo apt-get install -y cri-o
```

# References

- [CRI-O Packaging](https://github.com/cri-o/packaging/blob/main/README.md#add-the-kubernetes-repository-1)
