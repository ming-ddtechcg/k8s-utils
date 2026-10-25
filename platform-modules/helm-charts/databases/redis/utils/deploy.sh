#!/bin/sh

DEPLOYMENT_HOME=".."
UTILS_HOME="${DEPLOYMENT_HOME}/utils"
CHART_DIRECTORY="${DEPLOYMENT_HOME}/chart"

NAMESPACE=""
VALUES_OPTION=""
CHART_NAME=""
RELEASE_NAME=""
HELM_ACTION=""

PRG="$0"



#
# helm install
#
install()
{
    CHART_NAME_VAULES_YAML_FILE="${CHART_DIRECTORY}/${CHART_NAME}/values.yaml"
    CHART_NAME_VAULES_YAML_FILE_TAR="${CHART_DIRECTORY}/${CHART_NAME}/values.yaml.tar"

    if [ -s "${CHART_NAME_VAULES_YAML_FILE}" ]
    then
        tar cvf ${CHART_NAME_VAULES_YAML_FILE_TAR} \
            ${CHART_NAME_VAULES_YAML_FILE} > /dev/null 2>&1

        cp ${VALUES_FILE} ${CHART_DIRECTORY}/${CHART_NAME} > /dev/null 2>&1
    fi

    helm ${HELM_ACTION} ${RELEASE_NAME} \
        --namespace ${NAMESPACE} \
	${VALUES_OPTION} \
	${CHART_DIRECTORY}/${CHART_NAME}

    if [ -s "${CHART_NAME_VAULES_YAML_FILE_TAR}" ]
    then
        tar xvf ${CHART_NAME_VAULES_YAML_FILE_TAR} \
          -C .. > /dev/null 2>&1
        rm -f ${CHART_NAME_VAULES_YAML_FILE_TAR} > /dev/null 2>&1
    fi
}



#
# helm uninstall
#
uninstall()
{
    helm ${HELM_ACTION} ${RELEASE_NAME} \
        --namespace ${NAMESPACE}
}



#
# helm package
#
package()
{
    helm ${HELM_ACTION} \
	-d ${NAMESPACE} \
	${CHART_DIRECTORY}/${CHART_NAME} 
}



#
# usage
#
usage()
{
    echo ""
    echo "usage:"
    echo "    ${PRG} [option] [namespace] [chart_name] [value_file]"
    echo ""
    echo "option:     install, template, reinstall, uninstall, package"
    echo "namespace:  the resource place holder or the location of saving chart with option=package"
    echo "chart_name: the name of the Helm chart"
    echo "value_file: the values file for override the default values.yaml"
    echo ""
}



#
# start from here
#

OPTION="$1"
NAMESPACE="$2"
CHART_NAME="$3"
VALUES_FILE="$4"

if [ "${NAMESPACE}" = "" ]
then
    echo ""
    echo "ERROR: missing namespace, abort"
    echo ""
    usage
    exit 1
fi

if [ "${CHART_NAME}" = "" ]
then
    echo ""
    echo "ERROR: missing chart name, abort"
    echo ""
    usage
    exit 2
else
    RELEASE_NAME="${CHART_NAME}"
fi

if [ -s "${VALUES_FILE}" ]
then
    VALUES_OPTION="--values ${VALUES_FILE}"
fi

case ${OPTION} in
'template')
    HELM_ACTION="template"
    install
    ;;
'install')
    HELM_ACTION="install"
    install
    ;;
'install --dry-run --debug')
    HELM_ACTION="install --dry-run --debug"
    install
    ;;
'reinstall')
    HELM_ACTION="uninstall"
    uninstall

    sleep 2

    HELM_ACTION="install"
    install
    ;;
'uninstall')
    HELM_ACTION="uninstall"
    uninstall
    ;;
'package')
    HELM_ACTION="package"
    package
    ;;
*)
    echo ""
    echo "ERROR: invlaid option, abort"
    echo ""
    usage
    exit 2
    ;;
esac

exit 0
