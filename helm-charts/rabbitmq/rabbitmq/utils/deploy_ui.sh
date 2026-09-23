#!/bin/sh

DEPLOYMENT_HOME=".."
UTILS_HOME="${DEPLOYMENT_HOME}/utils"
CHART_DIRECTORY="${DEPLOYMENT_HOME}/chart"
DEPLOY_ENV_HOME="${DEPLOYMENT_HOME}/deploy-env"

. ${UTILS_HOME}/questionutils.sh ""

NAMESPACE=""
CHART_NAME=""
VALUES_FILE=""
KUSTOMIZE_AVAIL="false"
PRG="$0"
LOOP_DISPLAY_MENU="false"



#
# watching looping display menu state
#
watchLoopingDisplayMenucwState()
{
    case ${LOOP_DISPLAY_MENU} in
    'true')
        LOOP_DISPLAY_MENU="false"
	;;
    *)
        LOOP_DISPLAY_MENU="true"
	;;
    esac
}



#
# selects the values files
#
selectValuesFiles()
{
    while true
    do
        ENVS=`find ${DEPLOY_ENV_HOME} -name values.yaml`

        echo ""
        echo "list all possible environments"
        echo "===================================="
        for env in ${ENVS}
        do
	    VALUES_DIR=`dirname ${env}`
	    CHART_VALUES_DIR=`basename ${VALUES_DIR}`
	    ENVIRON_DIR=`dirname ${VALUES_DIR}`
	    LEVEL_UP_CHART_VALUES_DIR=`basename ${ENVIRON_DIR}`
	    echo "${LEVEL_UP_CHART_VALUES_DIR}/${CHART_VALUES_DIR}"
        done

	questionAndResponse "enter an environment"
        if [ "${ANSWER_REQUESTION_RESPONSE}" = "" ]
	then
	    echo ""
	    echo "WARNING: no environment is selected."
	    echo ""
	    continue
        fi

	FILE_PATH=`find ${DEPLOY_ENV_HOME} -name "values.yaml" | grep ${ANSWER_REQUESTION_RESPONSE}`

	if [ -s "${FILE_PATH}" ]
	then
	    echo ""
	    echo "INFO: values.yaml in ${ANSWER_REQUESTION_RESPONSE} is confirmed"
            VALUES_FILE="${FILE_PATH}"
	    CHART_NAME=`basename ${ANSWER_REQUESTION_RESPONSE}`
	    return
	fi
    done
}



#
# display menu
#
displayMenu()
{
    echo ""
    echo "${DISPLAY_CHART} deployment"
    echo "======================================================================"
    echo "namespace: ${NAMESPACE}"
    echo "chart name: ${CHART_NAME}"
    echo "values file: ${VALUES_FILE}"
    echo ""
    echo "options"
    echo "1.  namespace"
    echo "2.  select values file"
    echo "3.  edit values file"
    echo "4.  generate template YAML"
    echo "5.  debugging installation"
    echo "6.  install"
    echo "7.  uninstall"
    echo "8.  package"
    echo ""
    echo "18. shell environment"
    echo "19. loop this menu for refreshing screen"
    echo "20. exit"
}



#
# start from here
#

while true
do
    DISPLAY_CHART="<no chart is selected yet>"
    if [ "${CHART_NAME}" != "" ]
    then
        DISPLAY_CHART="${CHART_NAME}"
    fi

    displayMenu
    questionAndResponse "enter selection" "1 2 3 4 5 6 7 8 9 18 19 20"

    case ${ANSWER_REQUESTION_RESPONSE} in
    '1')
	questionAndResponse "enter a namespace"
	NAMESPACE="${ANSWER_REQUESTION_RESPONSE}"
	continue
        ;;
    '2')
	selectValuesFiles
	;;
    '3')
	if [ ! -s "${VALUES_FILE}" ]
	then
	    echo ""
            echo "ERROR: the values file is inaccessible."
	    echo ""
	    continue
	fi

	questionAndResponse "select a editor in (v)i or (n)ano (v/n)" "v n"
	case ${ANSWER_REQUESTION_RESPONSE} in
        'v')
            vi ${VALUES_FILE}
	    ;;
	'n')
	    nano ${VALUES_FILE}
	    ;;
	esac 
	
	continue
        ;;
    '4')
        if [ "${NAMESPACE}" = "" ]
	then
	    echo ""
	    echo "WARNING: missing namespace"
	    echo ""
	    continue
	fi

	echo ""
	echo "# YAML: BEGIN"
	echo "---"
	echo ""

	${UTILS_HOME}/deploy.sh template "${NAMESPACE}" "${CHART_NAME}" "${VALUES_FILE}"

	echo ""
	echo "---"
	echo "# YAML: END"
	echo ""
	continue
	;;
    '5')
	if [ "${NAMESPACE}" = "" ]
        then
            echo ""
            echo "WARNING: namespace is required"
            echo ""
            continue
        fi

	if [ ! -s "${VALUES_FILE}" ]
        then
            echo ""
            echo "WARNING: the values file is not specified."
            echo ""
            continue
        fi

	${UTILS_HOME}/deploy.sh "install --dry-run --debug" "${NAMESPACE}" "${CHART_NAME}" "${VALUES_FILE}"
        ;;
    '6')
	if [ "${NAMESPACE}" = "" ]
        then
            echo ""
            echo "WARNING: namespace is required"
            echo ""
            continue
        fi

	if [ ! -s "${VALUES_FILE}" ]
        then
            echo ""
            echo "WARNING: the values file is not specified."
            echo ""
            continue
        fi

	${UTILS_HOME}/deploy.sh install "${NAMESPACE}" "${CHART_NAME}" "${VALUES_FILE}"
        ;;
    '7')
	if [ "${NAMESPACE}" = "" ]
	then
	    echo ""
	    echo "WARNING: namespace is required"
	    echo ""
	    continue
	fi

	${UTILS_HOME}/deploy.sh uninstall "${NAMESPACE}" "${CHART_NAME}"
        ;;
    '8')
	questionAndResponse "enter location for saving chart file" 
        LOCATION="${ANSWER_REQUESTION_RESPONSE}"

	${UTILS_HOME}/deploy.sh package "${LOCATION}" "${CHART_NAME}"
        ;;
    '18')
	echo ""
	echo "type \"exit\" to return back to the menu screen"
        /bin/sh
	;;
    '19')
	trap watchLoopingDisplayMenucwState INT
	LOOP_DISPLAY_MENU="true"

        while [ "${LOOP_DISPLAY_MENU}" = "true" ]
        do
	    displayMenu
	    echo ""
	    echo "(cntrl-c to break the current loop)"
	    sleep 15
	done

	trap - watchLoopingDisplayMenucwState
	;;
    '20')
	echo ""
	echo "exit."
	echo ""
	break
	;;
    esac
done

exit 0
