# kubebuilder installation
To download kubebuilder binary and install to the local.

## Prerequisites

The go binary has to be installed prior to the kubebuilder installation.

## Installation

```console
curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
chmod +x kubebuilder && sudo install kubebuilder /usr/local/bin/kubebuilder
```
## References

- [Installation](https://book.kubebuilder.io/quick-start.html#installation)

