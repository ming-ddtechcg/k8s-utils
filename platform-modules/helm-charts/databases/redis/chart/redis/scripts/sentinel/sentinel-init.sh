#!/bin/sh

REDIS_ETC_HOME="/etc/redis"
REDIS_SENTINEL_ETC_CONFIG="${REDIS_ETC_HOME}/sentinel.conf"

_CURL_COMMAND="curl -s"
_RUNNING_NAMESPACE="redis"
_REDIS_SENTINEL_CONFIG="redis-sentinel-config-configmap"

REQUIREPASS=""
REDIS_SENTINEL_SERVER_PORT="5000"
REDIS_SERVER_PORT="6379"
RESOLVE_HOSTNAMES="yes"
ANNOUNCE_HOSTNAMES="yes"
FAILOVER_TIMEOUT="60000"
PARALLEL_SYNCS="1"
QUORUM="2"
DOWN_AFTER_MILLISECONDS="5000"



#
# retrieves token
#
fetechToken()
{
    if [ -f "/run/secrets/kubernetes.io/serviceaccount/token" ]
    then
        TOKEN=`cat /run/secrets/kubernetes.io/serviceaccount/token`
    fi
}



#
# fetch configMap/redis-config-configmap for the
# sentinel configurations
#
getSentinelConfig()
{
    CONFIGS=`${_CURL_COMMAND} \
        --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt \
        -H "Authorization: Bearer ${TOKEN}" \
        https://${KUBERNETES_PORT_443_TCP_ADDR}/api/v1/namespaces/${_RUNNING_NAMESPACE}/configmaps/${_REDIS_SENTINEL_CONFIG} \
        | jq -r '.data | [ .REQUIREPASS, .POD_PREFIX_NAME, .REDIS_SENTINEL_SERVER_PORT, .REDIS_SERVER_PORT, .RESOLVE_HOSTNAMES, .ANNOUNCE_HOSTNAMES, .FAILOVER_TIMEOUT, .PARALLEL_SYNCS, .QUORUM, .DOWN_AFTER_MILLISECONDS ] | join( ";" )'`

    #echo "CONFIGS: ${CONFIGS}"

    REQUIREPASS=`echo ${CONFIGS} | cut -d';' -f1`
    POD_PREFIX_NAME=`echo ${CONFIGS} | cut -d';' -f2`
    REDIS_SENTINEL_SERVER_PORT=`echo ${CONFIGS} | cut -d';' -f3`
    REDIS_SERVER_PORT=`echo ${CONFIGS} | cut -d';' -f4`
    RESOLVE_HOSTNAMES=`echo ${CONFIGS} | cut -d';' -f5`
    ANNOUNCE_HOSTNAMES=`echo ${CONFIGS} | cut -d';' -f6`
    FAILOVER_TIMEOUT=`echo ${CONFIGS} | cut -d';' -f7`
    PARALLEL_SYNCS=`echo ${CONFIGS} | cut -d';' -f8`
    QUORUM=`echo ${CONFIGS} | cut -d';' -f9`
    DOWN_AFTER_MILLISECONDS=`echo ${CONFIGS} | cut -d';' -f10`

    echo ""
    echo "REDIS_SENTINEL_SERVER_PORT: ${REDIS_SENTINEL_SERVER_PORT}"
    echo "POD_PREFIX_NAME: ${POD_PREFIX_NAME}"
    echo "REDIS_SERVER_PORT: ${REDIS_SERVER_PORT}"
    echo "RESOLVE_HOSTNAMES: ${RESOLVE_HOSTNAMES}"
    echo "ANNOUNCE_HOSTNAMES: ${ANNOUNCE_HOSTNAMES}"
    echo "FAILOVER_TIMEOUT: ${FAILOVER_TIMEOUT}"
    echo "PARALLEL_SYNCS: ${PARALLEL_SYNCS}"
    echo "QUORUM: ${QUORUM}"
    echo "DOWN_AFTER_MILLISECONDS: ${DOWN_AFTER_MILLISECONDS}"
    echo ""
}



#
# returns all redis pod names
#
getRedisPods()
{
    ${_CURL_COMMAND} \
        --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt \
        -H "Authorization: Bearer ${TOKEN}" \
        https://${KUBERNETES_PORT_443_TCP_ADDR}/api/v1/namespaces/${_RUNNING_NAMESPACE}/pods \
        | jq -r '.items[] | select( .metadata.annotations != null and .metadata.annotations."resource-type" != null and .metadata.annotations."resource-type" == "redis-pod" ) | .metadata.name'
}



#
# returns the redis service name
#
getRedisServiceName()
{
    POD_NAME="$1"

    if [ "${POD_NAME}" = "" ]
    then
        return
    fi

    ${_CURL_COMMAND} \
        --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt \
        -H "Authorization: Bearer ${TOKEN}" \
        https://${KUBERNETES_PORT_443_TCP_ADDR}/api/v1/namespaces/${_RUNNING_NAMESPACE}/pods/${POD_NAME} \
	| jq -r '. | select( .metadata.ownerReferences != null and .metadata.ownerReferences[0] != null and .metadata.ownerReferences[0].name != null ) | .metadata.ownerReferences[0].name'
}



#
# start from here
#

if [ "${RUNNING_NAMESPACE}" != "" ]
then
    _RUNNING_NAMESPACE="${RUNNING_NAMESPACE}"
fi

if [ "${REDIS_SENTINEL_CONFIG}" != "" ]
then
    _REDIS_SENTINEL_CONFIG="${REDIS_SENTINEL_CONFIG}"
fi


echo ""
echo "environment variables:"
echo "_RUNNING_NAMESPACE: ${_RUNNING_NAMESPACE}"
echo "_REDIS_SENTINEL_CONFIG: ${_REDIS_SENTINEL_CONFIG}"
echo ""


fetechToken

getSentinelConfig

REDIS_PASSWORD=""
if [ "${REQUIREPASS}" != "" ] && [ "${REQUIREPASS}" != "NONE" ]
then
    DECODED=`echo "${REQUIREPASS}" | base64 -d 2> /dev/null`
    ENCODED=`echo -n "${DECODED}" | base64 2> /dev/null`

    if [ "${REQUIREPASS}" = "${ENCODED}" ]
    then
	REQUIREPASS="${DECODED}"
        REDIS_PASSWORD="-a ${DECODED}"
    else
        REQUIREPASS=""
    fi
fi

HOSTNAME_FQDN=`hostname -f`
LOOK_REDIS_NODE_COUNT="0"
REDIS_SERVICE_NAME=""
MASTER=""
while true
do
    MASTER=""
    NODES=`getRedisPods`

    if [ "${LOOK_REDIS_NODE_COUNT}" -gt "1000" ]
    then
        echo ""
	echo "WARNING: unable to locate all redis nodes, abort"
	echo ""

	exit 1
    fi

    LOOK_REDIS_NODE_COUNT=`expr ${LOOK_REDIS_NODE_COUNT} + 1`

    if [ "${NODES}" = "" ]
    then
        sleep 5
    fi

    for each_node in ${NODES}
    do
	if [ "${REDIS_SERVICE_NAME}" = "" ]
	then
	    REDIS_SERVICE_NAME=`getRedisServiceName ${each_node}`
	fi

        each_node_fqdn=`echo ${HOSTNAME_FQDN} | sed -e 's|'"${POD_PREFIX_NAME}"'-[0-9]\.|'"${each_node}"'.|'`
	each_node_fqdn=`echo ${each_node_fqdn} | sed -e 's|.'"${POD_PREFIX_NAME}"'.|.'"${REDIS_SERVICE_NAME}"'.|'`

	echo ""
        echo "finding master at ${each_node_fqdn}"
        MASTER=`redis-cli --no-auth-warning --raw -h ${each_node_fqdn} -p ${REDIS_SERVER_PORT} ${REDIS_PASSWORD} info replication | awk '{ print $1 }' | grep master_host: | cut -d ":" -f2`

        if [ "${MASTER}" = "" ]
        then
            MASTER=""
        else
            echo "found ${MASTER}"
            break
        fi
    done

    if [ "${MASTER}" != "" ]
    then
        break
    else
        sleep 5
    fi
done

if [ ! -d "${REDIS_ETC_HOME}" ]
then
    mkdir -p ${REDIS_ETC_HOME} > /dev/null 2>&1
fi

echo "sentinel monitor mymaster ${MASTER} ${REDIS_SERVER_PORT} ${QUORUM}" > ${REDIS_SENTINEL_ETC_CONFIG}
echo "port ${REDIS_SENTINEL_SERVER_PORT}" >> ${REDIS_SENTINEL_ETC_CONFIG}
echo "sentinel resolve-hostnames ${RESOLVE_HOSTNAMES}" >> ${REDIS_SENTINEL_ETC_CONFIG}
echo "sentinel announce-hostnames ${ANNOUNCE_HOSTNAMES}" >> ${REDIS_SENTINEL_ETC_CONFIG}
echo "sentinel down-after-milliseconds mymaster ${DOWN_AFTER_MILLISECONDS}" >> ${REDIS_SENTINEL_ETC_CONFIG}
echo "sentinel failover-timeout mymaster ${FAILOVER_TIMEOUT}" >> ${REDIS_SENTINEL_ETC_CONFIG}
echo "sentinel parallel-syncs mymaster ${PARALLEL_SYNCS}" >> ${REDIS_SENTINEL_ETC_CONFIG}

if [ "${REQUIREPASS}" != "" ]
then
    echo "sentinel auth-pass mymaster ${REQUIREPASS}" >> ${REDIS_SENTINEL_ETC_CONFIG}
fi

exit 0

