#!/bin/bash

SOLR_PATH=$1
COLLECTION_NAME=$2
CONFIG_DIRECTORY=$3
SOLR_PORT=$4

function create_solr_example() {
    cd $SOLR_PATH/bin
    OUTPUT=$(./solr create_core -c $COLLECTION_NAME -d $CONFIG_DIRECTORY -p $SOLR_PORT)
    echo $OUTPUT
}

create_solr_example