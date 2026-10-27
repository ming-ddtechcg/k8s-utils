#!/bin/sh

mkdir modules
cp ../modules/rejson.so modules
cp ../configs/redis.conf_7.4 redis.conf

docker build -f Dockerfile -t harbor.ddtechcg.com:5001/k8s-utils/redis:7.4-alpine .

rm -fr modules
rm -f redis.conf

