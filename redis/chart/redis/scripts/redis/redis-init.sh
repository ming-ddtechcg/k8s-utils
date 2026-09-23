#!/bin/sh

REDIS_ETC_HOME="/etc/redis"
REDIS_ETC_CONFIG="${REDIS_ETC_HOME}/redis.conf"

_CURL_COMMAND="curl -s"
_RUNNING_NAMESPACE="redis"
_REDIS_CONFIG="redis-config-configmap"

TOKEN=""
MASTERUSER=""
MASTERAUTH=""
REQUIREPASS=""
POD_PREFIX_NAME=""
REDIS_SERVER_PORT="6379"
REDIS_SENTINAL_SERVER_NAME=""
REDIS_SENTINAL_SERVER_PORT="5000"
NUMBER_OF_DATABSE="16"



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
# redis configurations
#
getRedisConfig()
{
    CONFIGS=`${_CURL_COMMAND} \
        --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt \
        -H "Authorization: Bearer ${TOKEN}" \
        https://${KUBERNETES_PORT_443_TCP_ADDR}/api/v1/namespaces/${_RUNNING_NAMESPACE}/configmaps/${_REDIS_CONFIG} \
        | jq -r '.data | [ .MASTERUSER, .MASTERAUTH, .REQUIREPASS, .POD_PREFIX_NAME, .REDIS_SERVER_PORT, .REDIS_SENTINAL_SERVER_NAME, .REDIS_SENTINAL_SERVER_PORT, .NUMBER_OF_DATABASE ] | join( ";" )'`

    #echo "CONFIGS: ${CONFIGS}"

    MASTERUSER=`echo ${CONFIGS} | cut -d';' -f1`
    MASTERAUTH=`echo ${CONFIGS} | cut -d';' -f2`
    REQUIREPASS=`echo ${CONFIGS} | cut -d';' -f3`
    POD_PREFIX_NAME=`echo ${CONFIGS} | cut -d';' -f4`
    REDIS_SERVER_PORT=`echo ${CONFIGS} | cut -d';' -f5`
    REDIS_SENTINAL_SERVER_NAME=`echo ${CONFIGS} | cut -d';' -f6`
    REDIS_SENTINAL_SERVER_PORT=`echo ${CONFIGS} | cut -d';' -f7`
    NUMBER_OF_DATABASE=`echo ${CONFIGS} | cut -d';' -f8`

    echo ""
    echo "MASTERUSER: ${MASTERUSER}"
    echo "POD_PREFIX_NAME: ${POD_PREFIX_NAME}"
    echo "REDIS_SERVER_PORT: ${REDIS_SERVER_PORT}"
    echo "REDIS_SENTINAL_SERVER_NAME: ${REDIS_SENTINAL_SERVER_NAME}"
    echo "REDIS_SENTINAL_SERVER_PORT: ${REDIS_SENTINAL_SERVER_PORT}"
    echo "NUMBER_OF_DATABASE: ${NUMBER_OF_DATABASE}"
    echo ""
}



#
# start from here
#

if [ "${RUNNING_NAMESPACE}" != "" ]
then
    _RUNNING_NAMESPACE="${RUNNING_NAMESPACE}"
fi

if [ "${REDIS_CONFIG}" != "" ]
then
    _REDIS_CONFIG="${REDIS_CONFIG}"
fi


echo ""
echo "environment variables:"
echo "_RUNNING_NAMESPACE: ${_RUNNING_NAMESPACE}"
echo "_REDIS_CONFIG: ${_REDIS_CONFIG}"
echo ""

fetechToken

getRedisConfig

if [ ! -d "${REDIS_ETC_HOME}" ]
then
    mkdir -p ${REDIS_ETC_HOME} > /dev/null 2>&1
fi

MASTERAUTH_SET="false"
if [ "${MASTERAUTH}" != "" ] && [ "${MASTERAUTH}" != "NONE" ]
then
    DECODED=`echo "${MASTERAUTH}" | base64 -d 2> /dev/null`
    ENCODED=`echo -n "${DECODED}" | base64 2> /dev/null`

    if [ "${MASTERAUTH}" = "${ENCODED}" ]
    then
	MASTERAUTH="${DECODED}"

	echo "" >> ${REDIS_ETC_CONFIG}
        echo "masterauth ${MASTERAUTH}" >> ${REDIS_ETC_CONFIG}

	MASTERAUTH_SET="true"
    fi
fi

if [ "${MASTERAUTH_SET}" = "true" ]
then
    if [ "${MASTERUSER}" != "" ] && [ "${MASTERUSER}" != "NONE" ]
    then
        echo "masteruser ${MASTERUSER}" >> ${REDIS_ETC_CONFIG}
	echo "user ${MASTERUSER} on >${MASTERAUTH} ~* &* +@all" >> ${REDIS_ETC_CONFIG}
    else
        echo "masteruser redis" >> ${REDIS_ETC_CONFIG}
	echo "user redis on >${MASTERAUTH} ~* &* +@all" >> ${REDIS_ETC_CONFIG}
    fi
fi

if [ "${REQUIREPASS}" != "" ] && [ "${REQUIREPASS}" != "NONE" ]
then
    DECODED=`echo "${REQUIREPASS}" | base64 -d 2> /dev/null`
    ENCODED=`echo -n "${DECODED}" | base64 2> /dev/null`

    if [ "${REQUIREPASS}" = "${ENCODED}" ]
    then
        echo "requirepass ${DECODED}" >> ${REDIS_ETC_CONFIG}
    fi
fi

if [ "${REDIS_SERVER_PORT}" = "" ]
then
    REDIS_SERVER_PORT="6379"
fi

if [ "${NUMBER_OF_DATABASE}" = "" ]
then
    NUMBER_OF_DATABASE="16"
fi

echo "port ${REDIS_SERVER_PORT}" >> ${REDIS_ETC_CONFIG}
echo "databases ${NUMBER_OF_DATABASE}" >> ${REDIS_ETC_CONFIG}

echo "finding master..."

MASTER_FDQN=`hostname  -f | sed -e 's|'"${POD_PREFIX_NAME}"'-[0-9]\.|'"${POD_PREFIX_NAME}"'-0.|'`
SENTINEL_FDQN=`hostname  -f | sed -e 's|'"${POD_PREFIX_NAME}"'-[0-9]\.|'"${REDIS_SENTINAL_SERVER_NAME}"'.|'`

SENTINEL_PING=`redis-cli -h ${SENTINEL_FDQN} ${REDIS_SENTINAL_SERVER_PORT} ping`

if [ "${SENTINEL_PING}" != "PONG" ]
then
    echo "master not found, defaulting to ${POD_PREFIX_NAME}-0"

    if [ "`hostname`" = "${POD_PREFIX_NAME}-0" ]
    then
        echo "this is ${POD_PREFIX_NAME}-0, not updating config..."
    else
        echo "updating redis.conf..."

        echo "replicaof ${MASTER_FDQN} ${REDIS_SERVER_PORT}" >> /etc/redis/redis.conf
    fi
else
    echo "sentinel found, finding master"

    MASTER=`redis-cli -h ${REDIS_SENTINAL_SERVER_NAME} -p ${REDIS_SENTINAL_SERVER_PORT} sentinel get-master-addr-by-name mymaster | grep -E '(^'"${POD_PREFIX_NAME}"'-\d{1,})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})'`

    echo "master found : ${MASTER}, updating redis.conf"

    echo "replicaof ${MASTER} ${REDIS_SERVER_PORT}" >> /etc/redis/redis.conf
fi

exit 0

