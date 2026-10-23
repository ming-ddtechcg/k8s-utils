#!/bin/sh

GF_TMP_DB="/tmp/gf-$$"

. ./questionutils.sh ""



#
# start from here
#

questionAndResponse "enter a namespace"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

POD_NAME=`kubectl get pods -n ${NAMESPACE} --no-headers -o wide | grep "^sra-aim-grafana-dashboard-" | awk '{ print $1 }' | head -1`

if [ "${POD_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard pod, abort"
    echo ""
    exit 1
fi

PVC_NAME=`kubectl get pod/$POD_NAME -n ${NAMESPACE} -o json | jq -r '.spec.volumes[] | select( .name == "grafana-db-pvc" ) | .persistentVolumeClaim.claimName'`

if [ "${PVC_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard PVC, abort"
    echo ""
    exit 2
fi

PV_NAME=`kubectl get pvc/${PVC_NAME} -n ${NAMESPACE} --no-headers | awk '{ print $3 }'`

if [ "${PV_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard PV, abort"
    echo ""
    exit 3
fi

NFS_SERVER=`kubectl get pv/${PV_NAME} -o json | jq -r '.spec.nfs.server'`
NFS_PATH=`kubectl get pv/${PV_NAME} -o json | jq -r '.spec.nfs.path'`

echo ""
echo "mount ${NFS_SERVER}:${NFS_PATH} to ${GF_TMP_DB}"
mkdir -p ${GF_TMP_DB}
sudo mount ${NFS_SERVER}:${NFS_PATH} ${GF_TMP_DB}

if [ -f "${GF_TMP_DB}/grafana.db" ]
then
    sudo sqlite3 ${GF_TMP_DB}/grafana.db '.clone '${GF_TMP_DB}'/grafana-new.db'
    sudo mv ${GF_TMP_DB}/grafana.db ${GF_TMP_DB}/grafana-old.db
    sudo mv ${GF_TMP_DB}/grafana-new.db ${GF_TMP_DB}/grafana.db

    echo ""
    echo "list all files for grafana.db.$$"
    echo "============================================================="
    ls -l ${GF_TMP_DB}
    echo ""
fi

echo ""
echo "umount ${GF_TMP_DB}"
sudo umount ${GF_TMP_DB}
sudo rm -fr ${GF_TMP_DB} > /dev/null 2>&1

exit 0

