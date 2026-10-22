#!/bin/sh

cp ../configs/redis.conf_8.4.0 redis.conf

docker build -f Dockerfile -t harbor.ddtechcg.com:5001/k8s-utils/redis:8.4.0-alpine .

rm -f redis.conf

