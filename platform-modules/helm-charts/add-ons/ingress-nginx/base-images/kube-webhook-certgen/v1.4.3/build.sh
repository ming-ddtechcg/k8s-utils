#!/bin/sh

docker build -f Dockerfile -t harbor.ddtechcg.com:5001/k8s-utils/ingress-nginx/kube-webhook-certgen:v1.4.3 .

