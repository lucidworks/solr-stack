#!/bin/bash

solr_path=$1
collection_name=$2
config_directory=$3
solr_port=$4
shards=$5
replication=$6
log_file=$7

function create_solr_cloud_example() {
	cd $solr_path/latest/bin
	output=$(./solr create_collection -c $collection_name -d $config_directory -p $solr_port -s $shards -rf $replication)
	echo $output
	echo $output >> $log_file
}

create_solr_cloud_example