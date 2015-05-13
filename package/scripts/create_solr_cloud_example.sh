#!/bin/bash

SOLR_PATH=$1
COLLECTION_NAME=$2
CONFIG_DIRECTORY=$3
SOLR_PORT=$4
SHARDS=$5
REPLICATION=$6
LOG_FILE=$7

function create_solr_cloud_example() {
    cd $SOLR_PATH/latest/bin
    OUTPUT=$(./solr create_collection -c $COLLECTION_NAME -d $CONFIG_DIRECTORY -p $SOLR_PORT -s $SHARDS -rf $REPLICATION)
    echo $OUTPUT
    echo $OUTPUT >> $LOG_FILE
}

create_solr_cloud_example