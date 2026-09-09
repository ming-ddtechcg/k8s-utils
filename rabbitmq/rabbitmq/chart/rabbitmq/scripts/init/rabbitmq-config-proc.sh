#!/bin/sh

RABBITMQ_CONIFG_FILE="/etc/rabbitmq/rabbitmq.conf"

_CLUSTER_DOMAIN="cluster.local"
_RABBITMQ_AMQP_PORT="5672"
_RABBITMQ_CONSOLE_LOG="false"



#
# starts from here
#

if [ "${CLUSTER_DOMAIN}" != "" ]
then
    _CLUSTER_DOMAIN="${CLUSTER_DOMAIN}"
fi

if [ "${RABBITMQ_AMQP_PORT}" != "" ]
then
    _RABBITMQ_AMQP_PORT="${RABBITMQ_AMQP_PORT}"
fi

if [ "${RABBITMQ_CONSOLE_LOG}" != "" ]
then
    _RABBITMQ_CONSOLE_LOG="${RABBITMQ_CONSOLE_LOG}"
fi

sed -e 's|~~CLUSTER_DOMAIN~~|'${CLUSTER_DOMAIN}'|g' \
    -e 's|~~RABBITMQ_AMQP_PORT~~|'${RABBITMQ_AMQP_PORT}'|g' \
    -e 's|~~RABBITMQ_CONSOLE_LOG~~|'${RABBITMQ_CONSOLE_LOG}'|g' \
    ${RABBITMQ_CONIFG_FILE} \
    > ${RABBITMQ_CONIFG_FILE}.1

if [ -s "${RABBITMQ_CONIFG_FILE}.1" ]
then
    mv ${RABBITMQ_CONIFG_FILE}.1 ${RABBITMQ_CONIFG_FILE}
else
    echo ""
    echo "ERROR: unable to process RabbitMQ configuration file, abort"
    echo ""

    exit 1
fi

exit 0
