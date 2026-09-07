#!/bin/sh

NAMESPACE=""
CONTAINER_NAME="ingress-nginx"

. ./questionutils.sh ""



#
# start from here
#

questionAndResponse "enter a namespace"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

POD_NAMES=`kubectl get pods -n ${NAMESPACE} --no-headers -o wide | grep "^ingress-nginx-" | grep -v "^ingress-nginx-admission-" | awk '{ print $1":"$7 }'`

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
POD_NAME="${ANSWER_REQUESTION_RESPONSE}"

OPTIONS=""
EXTERNAL_CMDS=""
questionAndResponse "options: 1. log, 2. tail log, 3. tail log with more, 4. write to file, 5. show command" "1 2 3 4 5"
case ${ANSWER_REQUESTION_RESPONSE} in
'1')
    OPTIONS=""
    ;;
'2')
    OPTIONS="-f"
    ;;
'3')
    OPTIONS="-f"
    EXTERNAL_CMDS="|:more"
    ;;
'4')
    questionAndResponse "the path and filename"
    EXTERNAL_CMDS=">:${ANSWER_REQUESTION_RESPONSE}"
    ;;
'5')
    EXTERNAL_CMDS="show:cmd"
    ;;
esac

./pod-exec-template.sh ${NAMESPACE} ${POD_NAME} "logs" "-c ${CONTAINER_NAME} ${OPTIONS}" "${EXTERNAL_CMDS}"

exit 0

