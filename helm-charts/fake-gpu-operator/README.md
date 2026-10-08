# Fake GPU Operator

## Installation

```bash
helm upgrade -i gpu-operator \
  oci://ghcr.io/run-ai/fake-gpu-operator/fake-gpu-operator \
  --namespace gpu-operator --create-namespace --version 0.2.1
```

to label a node to simulate the GPU:

```bash
kubectl label node <node-name> run.ai/simulated-gpu-node-pool=default
```

## References

- [Fake GPU Operator](https://github.com/run-ai/fake-gpu-operator)

