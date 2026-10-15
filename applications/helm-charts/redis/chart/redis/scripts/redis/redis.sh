#!/bin/sh

REDIS_CONF="/etc/redis/redis.conf"
REDIS_SERVER="/usr/local/bin/redis-server"



#
# start from here
#

if [ ! -s "${REDIS_CONF}" ]
then
    echo ""
    echo "ERROR: missing redis.conf, abort"
    echo ""

    exit 1
fi

while true
do
    echo ""
    echo "start the redis server now..."

    ${REDIS_SERVER} ${REDIS_CONF} 

    sleep 1
done

exit 0

