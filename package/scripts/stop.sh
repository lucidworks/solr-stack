#!/bin/bash

solr_path=$1

solr_port=$2

log_file=$3

pid_file=$4

function stop_solr(){
	if [ -f "$pid_file" ]; then
		cd $solr_path/latest/bin
		echo "Stopping Solr..."	
		output=$(./solr stop -p $solr_port)
		echo $output
		echo $output >> $log_file
		rm $pid_file
	else
		error_msg="The pid file $pid_file does not exist" >> $log_file
		echo $error_msg
		echo $error_msg >> $log_file
	fi
}

stop_solr