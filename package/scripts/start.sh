#!/bin/bash

#Path to start.jar e.g. /opt/solr
SOLR_PATH=$1

#LOG_FILE e.g. /var/log/solr.log
LOG_FILE=$2

#PID file e.g. /var/run/solr.PID
PID_FILE=$3

#zookeeper hosts
ZK_HOSTS=$4

ZK_DIRECTORY=$5

SOLR_PORT=$6

SOLR_CLOUD=$7
 
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
            ERROR_MSG="Solr is running, it cannot be started again"
            echo $ERROR_MSG
            echo $ERROR_MSG >> $LOG_FILE
            exit 1
        fi
    fi
}

function validate_solr_port() {
    OUTPUT=$(netstat -lnt | awk -v v1=$SOLR_PORT '$6 == "LISTEN" && $4 ~ ":"+v1')
    echo $OUTPUT | grep "LISTEN"
    
    if [ "$?" -eq 0 ]; then
        ERROR_MSG="The port $SOLR_PORT is not available"
        echo $ERROR_MSG
        echo $ERROR_MSG >> $LOG_FILE
        exit 1
    fi
}

function start_standalone() {
    echo "Starting Solr..." >> $LOG_FILE
    OUTPUT=`./solr start -p $SOLR_PORT`
    echo $OUTPUT >> $LOG_FILE
    PID=`echo $OUTPUT | sed -e 's/.*PID=\(.*\)).*/\1/'`
    echo $PID > $PID_FILE
}

function start_solr_cloud(){
    echo "Starting Solr Cloud..." >> $LOG_FILE
    echo "Zookeeper ensemble $ZK_HOSTS$ZK_DIRECTORY" >> $LOG_FILE
    OUTPUT=`./solr start -cloud -z $ZK_HOSTS$ZK_DIRECTORY -p $SOLR_PORT`
    echo $OUTPUT >> $LOG_FILE	
    PID=`echo $OUTPUT | sed -e 's/.*pid=\(.*\)).*/\1/'`
    echo $PID > $PID_FILE
}

function start_solr(){
    if (($SOLR_CLOUD == "True")); then
        start_solr_cloud
    else
        start_standalone
    fi
}

validate_pid_dir

cd $SOLR_PATH/latest/bin

validate_node_status
validate_solr_port
start_solr