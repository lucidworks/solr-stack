#!/bin/bash

#Path to start.jar e.g. /opt/solr
SOLR_PATH=$1

#PID file e.g. /var/run/solr.PID
PID_FILE=$2

#zookeeper hosts
ZK_HOSTS=$3

ZK_DIRECTORY=$4

SOLR_PORT=$5

SOLR_CLOUD=$6

HDFS_URL=$7

HDFS_FOLDER=$8

SOLR_MEMORY=$9

ENABLE_HDFS=${10}

CUSTOM_COMMAND=${11}

SOLR_LOG=${12}
 
PID_DIR=$(dirname "$PID_FILE")

function validate_pid_dir() {
    if [ ! -d "$PID_DIR" ]; then
        echo "Creating PID_DIR: $PID_DIR"
        mkdir -p $PID_DIR
    fi
}

function validate_node_status() {
    if [ -f "$PID_FILE" ]; then
        OUTPUT=$(./solr status)
        echo $OUTPUT | grep "No Solr nodes are running."
        
        if [ "$?" -eq 1 ]; then
            echo $OUTPUT
            ERROR_MSG="Solr is running, it cannot be started again"
            echo $ERROR_MSG
            exit 1
        fi
    fi
}

function validate_solr_port() {
    OUTPUT=$(netstat -lnt | awk -v v1=$SOLR_PORT '$6 == "LISTEN" && $4 ~ ":"+v1')
    echo $OUTPUT | grep "LISTEN"
    
    if [ "$?" -eq 0 ]; then
        echo $OUTPUT
        ERROR_MSG="The port $SOLR_PORT is not available"
        echo $ERROR_MSG
        exit 1
    fi
}

function start_solr(){
            
    CMD="$SOLR_PATH/bin/solr start"
    
    if [ "$SOLR_CLOUD" == "True" ]; then
        echo "Starting Solr Cloud ..."
        echo "Zookeeper ensemble $ZK_HOSTS$ZK_DIRECTORY"
        CMD="$CMD -cloud -z $ZK_HOSTS$ZK_DIRECTORY"
    else
        echo "Starting Solr Standalone ..."
    fi
        
    if [ "$ENABLE_HDFS" == "True" ]; then
        CMD="$CMD -Dsolr.directoryFactory=HdfsDirectoryFactory -Dsolr.lock.type=hdfs -Dsolr.hdfs.home=$HDFS_URL$HDFS_FOLDER"
    fi
        
    CMD="$CMD -p $SOLR_PORT -m $SOLR_MEMORY $CUSTOM_COMMAND"
    
    echo $CMD
    
    OUTPUT=$($CMD)
    echo $OUTPUT
    PID=$(cat solr-$SOLR_PORT.pid)
    echo $PID > $PID_FILE
    
    SOLR_LOG_DIR=$(dirname "$SOLR_LOG")
    SOLR_LOGS=$SOLR_LOG_DIR/logs
    
    if [ ! -d "$SOLR_LOGS" ]; then
        echo "Creating symbolic link of $SOLR_PATH/server/logs/ to $SOLR_LOGS"
        ln -s $SOLR_PATH/server/logs/ $SOLR_LOGS
    fi
}

validate_pid_dir

cd $SOLR_PATH/bin

validate_node_status
validate_solr_port
start_solr