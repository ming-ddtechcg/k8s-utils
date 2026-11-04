# Kubernetes (k8) resource converter
It is a tool to convert the CPU/memory resource units to the most minimum unit, see the following help:

```console
$ ./k8s-resource-converter 

Usage:
version: 1.1
     ./k8s-resource-converter [options] 

options:
--help                  this help menu
--resource-type=cpu     converts the resource with the CPU format to millicpu
--resource-type=memory  converts the resource with the memory format to byte
--resource-type=storage converts the resource with the storage format to byte

Examples:
  # prints the help menu:
  ./k8s-resource-converter --help

  # converts the CPU resource with 100m:
  echo "100m" | ./k8s-resource-converter --resource-type=cpu

  # converts the CPU resouce with 0.1 (core):
  echo "0.1" | ./k8s-resource-converter --resource-type=cpu

  # converts the CPU resource with 2 (cores)
  echo "2" | ./k8s-resource-converter --resource-type=cpu

  # converts the memory resource with 0.2Gi
  echo "0.2Gi" | ./k8s-resource-converter --resource-type=memory

  # converts the memory resource with 2Gi
  echo "2Gi" | ./k8s-resource-converter --resource-type=memory
```


