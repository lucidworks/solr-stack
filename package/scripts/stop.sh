#!/bin/bash

SOLR_PATH=$1

SOLR_PORT=$2

LOG_FILE=$3

PID_FILE=$4

function stop_solr(){
    if [ -f "$PID_FILE" ]; then
        cd $SOLR_PATH/latest/bin
        echo "Stopping Solr..."	
        output=$(./solr stop -p $SOLR_PORT)
        echo $output
        echo $output >> $LOG_FILE
        rm $PID_FILE
    else
        error_msg="The pid file $PID_FILE does not exist" >> $LOG_FILE
        echo $error_msg
        echo $error_msg >> $LOG_FILE
    fi
}

stop_solr