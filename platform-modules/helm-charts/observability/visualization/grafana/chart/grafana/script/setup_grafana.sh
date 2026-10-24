#!/bin/sh


#
# starts from here
#

if [ ! -d "/var/lib/grafana/dashboards" ]
then
    mkdir -p /var/lib/grafana/dashboards
fi

if [ ! -d "/var/lib/grafana/db" ]
then
    mkdir -p /var/lib/grafana/db
fi

if [ -d "/tmp/src-datasources" ] &&
   [ -d "/tmp/dest-datasources" ]
then
    cp /tmp/src-datasources/* /tmp/dest-datasources

    echo ""
    echo "INFO: copying datasources is completed."
fi

if [ -d "/tmp/src-dashboards" ] &&
   [ -d "/tmp/dest-dashboards" ]
then
    cp /tmp/src-dashboards/* /tmp/dest-dashboards

    echo ""
    echo "INFO: copying dashboard provider is completed."
fi

if [ "${EXTERNAL_DASHBOARD_DIRECTORY_NAME}" != "" ] &&
   [ -d "/tmp/src-custom-dashboards" ]
then
    if [ ! -d "/var/lib/grafana/dashboards/${EXTERNAL_DASHBOARD_DIRECTORY_NAME}" ]
    then
        mkdir -p /var/lib/grafana/dashboards/${EXTERNAL_DASHBOARD_DIRECTORY_NAME}
    fi

    if [ ! -f "/var/lib/grafana/dashboards/${EXTERNAL_DASHBOARD_DIRECTORY_NAME}/.inited" ]
    then
        cp /tmp/src-custom-dashboards/*.json \
            /var/lib/grafana/dashboards/${EXTERNAL_DASHBOARD_DIRECTORY_NAME}
        touch /var/lib/grafana/dashboards/${EXTERNAL_DASHBOARD_DIRECTORY_NAME}/.inited

        echo ""
        echo "INFO: copying custom dashboards are completed."
    fi
fi

if [ -d "/tmp/src-ini" ] &&
   [ -d "/tmp/dest-ini" ] &&
   [ -s "/tmp/src-ini/grafana.ini" ]
then
    cp /usr/local/tmp/grafana-ini-server-proc.py /tmp/grafana-ini-server-proc.py
    chmod +x /tmp/grafana-ini-server-proc.py
    export GRAFANA_INI="/tmp/src-ini/grafana.ini"
    /tmp/grafana-ini-server-proc.py > /tmp/dest-ini/grafana.ini
fi

exit 0

