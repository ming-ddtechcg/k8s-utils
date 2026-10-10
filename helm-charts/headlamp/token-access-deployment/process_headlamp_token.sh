#!/bin/sh

NAMESPACE="kube-system"


#
# starts from here
#

OPTION="$1"

case ${OPTION} in
'apply')
    kubectl apply -f kubernetes-headlamp-serviceaccount.yaml
    kubectl apply -f kubernetes-headlamp-secret.yaml
    kubectl apply -f kubernetes-headlamp-cluster-admin-role.yaml
    echo ""
    echo "applied the headlamp token"
    ;;
'remove')
    kubectl delete -f kubernetes-headlamp-cluster-admin-role.yaml
    kubectl delete -f kubernetes-headlamp-secret.yaml
    kubectl delete -f kubernetes-headlamp-serviceaccount.yaml
    echo ""
    echo "remove the headlamp token"
    ;;
*)
    echo ""
    echo "options are:"
    echo ""
    echo "apply  - apply the headlamp token adding procedure"
    echo "remove - remove the headlamp token"
    echo ""
    ;;
esac

exit 0

