#!/bin/sh


REDIS_ETC_HOME="/etc/redis"
REDIS_SENTINEL_ETC_CONFIG="${REDIS_ETC_HOME}/sentinel.conf"
REDIS_SENTINEL_SERVER="/usr/local/bin/redis-sentinel"



#
# start from here
#

if [ ! -s "${REDIS_SENTINEL_ETC_CONFIG}" ]
then
    echo ""
    echo "ERROR: missing sentinel.conf, abort"
    echo ""

    exit 1
fi

while true
do
    echo ""
    echo "start the redis sentinel server now..."

    ${REDIS_SENTINEL_SERVER} ${REDIS_SENTINEL_ETC_CONFIG}

    sleep 1
done

exit 0

