# Ingress Nginx tester
A tester to respond a Nginx default web page back to the caller through the Nginx controller and the service.


## directory structure

```
.
├── README.md
└── test-webservice
    ├── 00-namespace.yaml
    ├── 01-service.yaml
    ├── 02-deployment.yaml
    └── 03-ingress.yaml
```

## Deployment

Before deployment, there is an update in "03-ingress.yaml" for the incoming URL hostname:

```
...
spec:
  ingressClassName: nginx
  rules:
  - host: <hostname> <== update this
    http:
      paths:
      - backend:
          service:
            name: test-webservice
            port:
              number: 80
...
```

The Nginx controller will route the traffic with this specific hostname to the backend service with the service's listening port.


Deploy:

```bash
kubectl apply -f test-webservice
```

Undeploy:

```bash
kubectl delete -f test-webservice
```



