#!/bin/bash

solr_path=$1
collection_name=$2
config_directory=$3
solr_port=$4
log_file=$5

function create_solr_example() {
	cd $solr_path/latest/bin
	output=$(./solr create_core -c $collection_name -d $config_directory -p $solr_port)
	echo $output
	echo $output >> $log_file
}

create_solr_example