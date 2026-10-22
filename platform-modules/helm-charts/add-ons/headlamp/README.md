# Headlamp

## Installation

```console
$ helm install headlamp headlamp-0.45.0.tgz \
  --namespace kube-system \
  --set image.tag=v0.45.0 \
  --set image.registry=harbor.ddtechcg.com:5001 \
  --set image.repository=headlamp-k8s/headlamp
```

## token access

By default, the headlamp helm installation does not provide the token serviceAccount and Secret creation. In order to create an access token for logging in the headlamp UI with the following steps:

1. cd token-access-deployment 
2. execute "./process_headlamp_token.sh apply" to install the headlamp token resources (assume KUBECONFIG is proper setup)
3. execute "./retrieve_headlamp_token.sh" to retrieve the token
4. to remove the headlamp token resource with "./process_headlamp_token.sh remove"

## References

- [Using Helm](https://headlamp.dev/docs/latest/installation/in-cluster/#using-helm)
- [GitHub Repository](https://github.com/kubernetes-sigs/headlamp)
- [Headlamp Helm Chart](https://github.com/kubernetes-sigs/headlamp/blob/main/charts/headlamp/README.md)
- [Accessing using OpenID Connect](https://headlamp.dev/docs/latest/installation/in-cluster/oidc/)

