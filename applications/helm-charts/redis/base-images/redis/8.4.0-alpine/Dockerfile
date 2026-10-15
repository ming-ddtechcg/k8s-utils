FROM harbor.ddtechcg.com:5001/k8s-utils/redis:base-8.4.0-alpine

ENV VERSION="8.4.0-alpine"
ENV BUILDNAME="redis"

RUN mkdir /$BUILDNAME && \
    echo $VERSION > /$BUILDNAME/.version && \
    apk update && \
    apk add jq && \
    apk add curl && \
    apk add libgcc && \
    apk add gcompat

