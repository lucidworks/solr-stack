#!/bin/bash

SOLR_PATH=$1

SOLR_PORT=$2

PID_FILE=$3

function stop_solr(){
    if [ -f "$PID_FILE" ]; then
        cd $SOLR_PATH/bin
        echo "Stopping Solr..."	
        OUTPUT=$(./solr stop -p $SOLR_PORT)
        echo $OUTPUT
        rm $PID_FILE
    else
        ERROR_MSG="The pid file $PID_FILE does not exist"
        echo $ERROR_MSG
    fi
}

stop_solr