#!/bin/bash

SOLR_PATH=$1
PID_FILE=$2
SOLR_PORT=$3
LOG_FILE=$4
ERROR_MSG="Error: Solr is not running."

function validate_solr_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        cd $SOLR_PATH/latest/bin
        OUTPUT=$(./solr status)
        echo $OUTPUT | grep "Solr process $PID running on port $SOLR_PORT"
        
        if [ "$?" -eq 1 ]; then
            echo $ERROR_MSG
            echo $ERROR_MSG >> $LOG_FILE
            exit 1
        fi
    else
        echo $ERROR_MSG
        echo $ERROR_MSG >> $LOG_FILE
    fi
}

validate_solr_status