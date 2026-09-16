# RBAC exercise

A secret "test-secret" is created under the namespace "a" called "a-ns". A pod "test" is created under the namespace "b-ns" and needs to retreieve the value that stores in the secret "test-secret" from the namespace "a-ns"

This directory provides the environment setup to create the necessary k8s resources.  For accessing the secret, the following script provide the implementation:

```bash
_TOKEN=`cat /run/secrets/kubernetes.io/serviceaccount/token`
_CURL_COMMAND="curl -s"
_RUNNING_NAMESPACE="a-ns"
_SECRET_NAME="test-secret"

${_CURL_COMMAND} \
    --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt \
    -H "Authorization: Bearer ${_TOKEN}" \
    https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}/api/v1/namespaces/${_RUNNING_NAMESPACE}/secrets/${_SECRET_NAME} \
    | jq -r '.data'
```

The value of the secret is the base64 encoding.  It is required the base64 decoding, likes:

```
    | jq -r '.data.user' \
    | base64 -d
```

