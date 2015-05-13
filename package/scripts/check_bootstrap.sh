#!/bin/bash

ZK_DIRECTORY=$1
CONFIG_DIR=$2
SOLR_USER=$3
ZK_CLI_SHELL=$4
ZK_NODE1=$5
CLIENT_PORT=$6
COLLECTION_NAME=$7
LOG_FILE=$8

function check_bootstrap() {
    OUTPUT=$(/var/lib/ambari-agent/ambari-sudo.sh su $SOLR_USER -s /bin/bash - -c "source $CONFIG_DIR/zookeeper-env.sh ; echo 'get $ZK_DIRECTORY/configs/$COLLECTION_NAME' | ${ZK_CLI_SHELL} -server $ZK_NODE1:$CLIENT_PORT")
    echo $OUTPUT | grep "get $ZK_DIRECTORY/configs/$COLLECTION_NAME null"
	
	if [ "$?" -eq 1 ]; then
	    ERROR_MSG="Unsuccessful bootstrap, the collection $COLLECTION_NAME does not exist"
	    echo $ERROR_MSG
	    echo $ERROR_MSG >> $LOG_FILE
	    exit 1
	fi
}

check_bootstrap
