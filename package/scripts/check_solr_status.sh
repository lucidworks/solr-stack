#!/bin/bash

SOLR_PATH=$1
PID_FILE=$2
SOLR_PORT=$3
ERROR_MSG="Error: Solr is not running."
PID_FILE_ERROR="Solr PID file does not exist"

function validate_solr_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        cd $SOLR_PATH/bin
        OUTPUT=$(./solr status)
        echo $OUTPUT | grep "Solr process $PID running on port $SOLR_PORT"
        
        if [ "$?" -eq 1 ]; then
            echo $OUTPUT
            echo $ERROR_MSG
            exit 1
        fi
    else
        echo $PID_FILE_ERROR
        echo $ERROR_MSG
    fi
}

validate_solr_status