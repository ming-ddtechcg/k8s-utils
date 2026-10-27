FROM harbor.ddtechcg.com:5001/k8s-utils/redis:base-7.4-alpine

ENV VERSION="7.4-alpine"
ENV BUILDNAME="redis"

RUN mkdir /usr/local/modules
COPY modules/ /usr/local/modules/
COPY redis.conf /etc/redis/redis.conf

RUN mkdir /$BUILDNAME && \
    echo $VERSION > /$BUILDNAME/.version && \
    apk update && \
    apk add jq && \
    apk add curl && \
    apk add libgcc && \
    apk add gcompat

