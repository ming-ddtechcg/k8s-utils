#!/bin/sh

REDIS_ETC_HOME="/etc/redis"
REDIS_SENTINEL_ETC_CONFIG="${REDIS_ETC_HOME}/sentinel.conf"

_CURL_COMMAND="curl -s"
_RUNNING_NAMESPACE="redis"
_REDIS_SENTINEL_CONFIG="redis-sentinel-config-configmap"

REQUIREPASS=""
REDIS_SERVER_PORT="6379"



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
        | jq -r '.data | [ .REQUIREPASS, .POD_PREFIX_NAME, .REDIS_SERVER_PORT ] | join( ";" )'`

    #echo "CONFIGS: ${CONFIGS}"

    REQUIREPASS=`echo ${CONFIGS} | cut -d';' -f1`
    POD_PREFIX_NAME=`echo ${CONFIGS} | cut -d';' -f2`
    REDIS_SERVER_PORT=`echo ${CONFIGS} | cut -d';' -f3`

    echo ""
    echo "REDIS_SENTINEL_SERVER_PORT: ${REDIS_SENTINEL_SERVER_PORT}"
    echo "POD_PREFIX_NAME: ${POD_PREFIX_NAME}"
    echo "REDIS_SERVER_PORT: ${REDIS_SERVER_PORT}"
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
        REDIS_PASSWORD="-a ${DECODED}"
    fi
fi

HOSTNAME_FQDN=`hostname -f`
REDIS_SERVICE_NAME=""

NODES=`getRedisPods`

for each_node in ${NODES}
do
    if [ "${REDIS_SERVICE_NAME}" = "" ]
    then
        REDIS_SERVICE_NAME=`getRedisServiceName ${each_node}`
    fi

    each_node_fqdn=`echo ${HOSTNAME_FQDN} | sed -e 's|'"${POD_PREFIX_NAME}"'-[0-9]\.|'"${each_node}"'.|'`
    each_node_fqdn=`echo ${each_node_fqdn} | sed -e 's|.'"${POD_PREFIX_NAME}"'.|.'"${REDIS_SERVICE_NAME}"'.|'`

    echo ""
    echo "testing with ${each_node_fqdn}"
    redis-cli --no-auth-warning --raw -h ${each_node_fqdn} -p ${REDIS_SERVER_PORT} ${REDIS_PASSWORD} info replication
    echo ""
done

exit 0

