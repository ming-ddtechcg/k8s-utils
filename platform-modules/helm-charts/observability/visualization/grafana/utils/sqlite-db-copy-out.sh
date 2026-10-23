#!/bin/sh

GF_TMP_DB="/tmp/gf-$$"

. ./questionutils.sh ""



#
# start from here
#

questionAndResponse "enter a namespace"
NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"

questionAndResponse "the destination path to store grafana.db (for example: /tmp)"
DEST_GF_DIR="${ANSWER_REQUESTION_RESPONSE}"

if [ -d "${DEST_GF_DIR}" ]
then
    echo ""
    echo "ERROR: the destination path is inaccessible, abort"
    echo ""
    exit 1
fi

POD_NAME=`kubectl get pods -n ${NAMESPACE} --no-headers -o wide | grep "^sra-aim-grafana-dashboard-" | awk '{ print $1 }' | head -1`

if [ "${POD_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard pod, abort"
    echo ""
    exit 2
fi

PVC_NAME=`kubectl get pod/$POD_NAME -n ${NAMESPACE} -o json | jq -r '.spec.volumes[] | select( .name == "grafana-db-pvc" ) | .persistentVolumeClaim.claimName'`

if [ "${PVC_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard PVC, abort"
    echo ""
    exit 3
fi

PV_NAME=`kubectl get pvc/${PVC_NAME} -n ${NAMESPACE} --no-headers | awk '{ print $3 }'`

if [ "${PV_NAME}" = "" ]
then
    echo ""
    echo "ERROR: unable to locate sra-aim-grafana-dashboard PV, abort"
    echo ""
    exit 4
fi

NFS_SERVER=`kubectl get pv/${PV_NAME} -o json | jq -r '.spec.nfs.server'`
NFS_PATH=`kubectl get pv/${PV_NAME} -o json | jq -r '.spec.nfs.path'`

echo ""
echo "mount ${NFS_SERVER}:${NFS_PATH} to ${GF_TMP_DB}"
mkdir -p ${GF_TMP_DB}
sudo mount ${NFS_SERVER}:${NFS_PATH} ${GF_TMP_DB}

if [ -f "${GF_TMP_DB}/grafana.db" ]
then
    sudo cp ${GF_TMP_DB}/grafana.db ${DEST_GF_DIR}
    echo "copy ${GF_TMP_DB}/grafana.db ${DEST_GF_DIR}"
fi

echo ""
echo "umount ${GF_TMP_DB}"
sudo umount ${GF_TMP_DB}
sudo rm -fr ${GF_TMP_DB} > /dev/null

exit 0

