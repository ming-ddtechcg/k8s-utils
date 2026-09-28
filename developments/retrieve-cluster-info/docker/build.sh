#!/bin/sh


#
# starts from here
#

TAG="$1"

if [ "${TAG}" = "" ]
then
    echo ""
    echo "ERROR: missing the image tag, abort"
    echo ""

    exit 1
fi

cp ../bin/fetch-cluster-info .

docker build -f Dockerfile -t harbor.ddtechcg.com/playground/fetch-cluster-info:${TAG} .

rm -f fetch-cluster-info > /dev/null 2>&1

exit 0

