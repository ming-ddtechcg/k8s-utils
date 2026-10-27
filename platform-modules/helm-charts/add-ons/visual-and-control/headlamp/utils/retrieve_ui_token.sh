#!/bin/sh


#
# start from here
#

. ./questionutils.sh ""

questionAndResponse "Ensure KUBECONFIG has been set. Press enter to continue or Control-C to exit" "skip"

questionAndResponse "Enter the namespace that Kubernetes UI runs"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

questionAndResponse "Enter the name of the deployment"
DEPLOYMENT_NAME="${ANSWER_REQUESTION_RESPONSE}"

SECRET_NAME=`kubectl get secrets -n kube-system -o json \
    | jq -r '.items[] | select( .metadata.labels and .metadata.labels."app.kubernetes.io/name" != null and .metadata.labels."app.kubernetes.io/name" == "'"${DEPLOYMENT_NAME}"'" ) | .metadata.name'`

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

