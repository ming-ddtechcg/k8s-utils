#!/bin/sh


#
# start from here
#

. ./questionutils.sh ""

questionAndResponse "Ensure KUBECONFIG has been set. Press enter to continue or Control-C to exit" "skip"

questionAndResponse "Enter the namespace that Kubernetes Dashboard runs"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

SECRET_NAME=`kubectl get secrets -n ${NAMESPACE} -o json \
    | jq -r '.items[] | select( .metadata.annotations != null and .metadata.annotations."kubernetes.io/service-account.name" != null and .metadata.annotations."kubernetes.io/service-account.name" == "kubernetes-dashboard" ) | .metadata.name'`

if [ "${SECRET_NAME}" != "" ]
then
    echo ""
    echo "token:"
    echo ""

    kubectl get secret/${SECRET_NAME} -n ${NAMESPACE} -o jsonpath='{.data.token}' | base64 -d
else
    echo ""
    echo "ERROR: unable to locate the token secret, abort"
    echo ""

    exit 1
fi

echo ""
 
exit 0

