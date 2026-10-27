#!/bin/sh

docker build -f Dockerfile -t harbor.ddtechcg.com:5001/k8s-utils/sig-storage/nfs-subdir-external-provisioner:v4.0.2 .

