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

function start_standalone() {
    echo "Starting Solr Standalone..."
    OUTPUT=$(./solr start -p $SOLR_PORT -Dsolr.directoryFactory=HdfsDirectoryFactory -Dsolr.lock.type=hdfs -Dsolr.hdfs.home=$HDFS_URL$HDFS_FOLDER)
    echo $OUTPUT
    PID=$(cat solr-$SOLR_PORT.pid)
    echo $PID > $PID_FILE
}

function start_solr_cloud(){
    echo "Starting Solr Cloud..."
    echo "Zookeeper ensemble $ZK_HOSTS$ZK_DIRECTORY"
    OUTPUT=$(./solr start -cloud -z $ZK_HOSTS$ZK_DIRECTORY -p $SOLR_PORT -Dsolr.directoryFactory=HdfsDirectoryFactory -Dsolr.lock.type=hdfs -Dsolr.hdfs.home=$HDFS_URL$HDFS_FOLDER)
    echo $OUTPUT
    PID=$(cat solr-$SOLR_PORT.pid)
    echo $PID > $PID_FILE
}

function start_solr(){
    if [ "$SOLR_CLOUD" == "True" ]; then
        start_solr_cloud
    else
        start_standalone
    fi
}

validate_pid_dir

cd $SOLR_PATH/bin

validate_node_status
validate_solr_port
start_solr