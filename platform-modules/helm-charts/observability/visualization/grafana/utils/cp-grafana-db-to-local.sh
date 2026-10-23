#!/bin/sh

NAMESPACE=""
CONTAINER_NAME="grafana"

. ./questionutils.sh ""



#
# start from here
#

questionAndResponse "enter a namespace"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

POD_NAMES=`kubectl get pods -n ${NAMESPACE} --no-headers -o wide | grep "^grafana-" | awk '{ print $1":"$7 }'`

LIST_POD_NAMES=""
echo ""
echo "List pods:"
echo "=================================="
for pod_name in ${POD_NAMES}
do
    if [ "${LIST_POD_NAMES}" != "" ]
    then
        LIST_POD_NAMES="${LIST_POD_NAMES} "
    fi

    POD_NAME="`echo ${pod_name} | cut -d':' -f1`"
    LIST_POD_NAMES="${LIST_POD_NAMES}${POD_NAME}"

    echo "${POD_NAME} - `echo ${pod_name} | cut -d':' -f2`"
done

questionAndResponse "enter the pod name" "${LIST_POD_NAMES}"

kubectl cp -n ${NAMESPACE} -c ${CONTAINER_NAME} ${ANSWER_REQUESTION_RESPONSE}:/var/lib/grafana/grafana.db ${PWD}/grafana.db

exit 0

