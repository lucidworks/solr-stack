#!/bin/bash

ZK_DIRECTORY=$1
CONFIG_DIR=$2
SOLR_USER=$3
ZK_CLI_SHELL=$4
ZK_NODE1=$5
CLIENT_PORT=$6
TEST_CONNECTION_FILE=/tmp/zk_test_connection.log
TEST_FILE_EXISTS=/tmp/zk_test_file_exists.log
CREATE_FILE_OUTPUT=/tmp/zk_create_folder.log

function check_zk_status() {
    
    if [ ! -e $ZK_CLI_SHELL ]; then
        WARN_MSG="$ZK_CLI_SHELL does not exist, skipping validation"
        echo $WARN_MSG
        exit 0
    fi
    
	/var/lib/ambari-agent/ambari-sudo.sh su $SOLR_USER -s /bin/bash - -c "source $CONFIG_DIR/zookeeper-env.sh ; echo 'ls /' | ${ZK_CLI_SHELL} -server $ZK_NODE1:$CLIENT_PORT" 2>&1> $TEST_CONNECTION_FILE
	
	if [ -f $TEST_CONNECTION_FILE ]; then
	    grep "CONNECTED" $TEST_CONNECTION_FILE
	    
	    if [ "$?" -eq 1 ]; then
	        ERROR_MSG="Error: ZooKeeper is not running"
	        echo $ERROR_MSG
	        exit 1
	    fi
	    
	    OUTPUT=$(/var/lib/ambari-agent/ambari-sudo.sh su $SOLR_USER -s /bin/bash - -c "source $CONFIG_DIR/zookeeper-env.sh ; echo 'get $ZK_DIRECTORY' | ${ZK_CLI_SHELL} -server $ZK_NODE1:$CLIENT_PORT")
	    echo $OUTPUT | grep "get $ZK_DIRECTORY solr_cloud_node"
	    
	    if [ "$?" -eq 1 ]; then
	        echo $OUTPUT
	        OUTPUT=$(/var/lib/ambari-agent/ambari-sudo.sh su $SOLR_USER -s /bin/bash - -c "source $CONFIG_DIR/zookeeper-env.sh ; echo 'create $ZK_DIRECTORY solr_cloud_node' | ${ZK_CLI_SHELL} -server $ZK_NODE1:$CLIENT_PORT")
	        echo $OUTPUT
	    else
	        WARN_MSG="The $ZK_DIRECTORY directory already exists"
	        echo $WARN_MSG
	    fi
	fi
}

check_zk_status