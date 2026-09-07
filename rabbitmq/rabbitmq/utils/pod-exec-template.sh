#!/bin/sh



#
# start from here
#

NAMESPACE="$1"
POD_NAME="$2"
COMMAND="$3"
PARAMETERS="$4"
EXTERNAL_CMDS="$5"

if [ "${NAMESPACE}" = "" ] || [ "${POD_NAME}" = "" ] || 
   [ "${COMMAND}" = "" ] || [ "${PARAMETERS}" = "" ]
then
    echo ""
    echo "ERROR: parameter is insuffient, abort"
    echo ""
    exit 1
fi

if [ "$#" -eq 4 ]
then
    EXTERNAL_CMDS=""
fi

if [ "${EXTERNAL_CMDS}" = "" ]
then
    kubectl ${COMMAND} ${POD_NAME} -n ${NAMESPACE} ${PARAMETERS}
else
    KEY=`echo ${EXTERNAL_CMDS} | cut -d':' -f1`
    VALUE=`echo ${EXTERNAL_CMDS} | cut -d':' -f2`

    case ${KEY} in
    '|')
        kubectl ${COMMAND} ${POD_NAME} -n ${NAMESPACE} ${PARAMETERS} | ${VALUE}
	;;	
    '>')
        kubectl ${COMMAND} ${POD_NAME} -n ${NAMESPACE} ${PARAMETERS} > ${VALUE}
	;;
    'show')
	case ${VALUE} in
	'cmd')
	    echo "kubectl ${COMMAND} ${POD_NAME} -n ${NAMESPACE} ${PARAMETERS}"
	    ;;
	esac
        ;;
    esac
fi

exit 0

