#!/bin/bash

SOLR_PATH=$1

ZK_NODE1=$2

ZK_CLIENT_PORT=$3

ZK_DIRECTORY=$4

$SOLR_PATH/latest/server/scripts/cloud-scripts/zkcli.sh -zkhost $ZK_NODE1:$ZK_CLIENT_PORT -cmd put $ZK_DIRECTORY/clusterprops.json '{"urlScheme":"https"}'