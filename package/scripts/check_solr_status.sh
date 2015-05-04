#!/bin/bash

solr_path=$1
pid_file=$2
solr_port=$3
log_file=$4
error_msg="Error: Solr is not running."

function validate_solr_status() {
	if [ -f "$pid_file" ]; then
		pid=$(cat $pid_file)
		cd $solr_path/latest/bin
		output=$(./solr status)
		echo $output | grep "Solr process $pid running on port $solr_port"
		
		if [ "$?" -eq 1 ]; then
			echo $error_msg
			echo $error_msg >> $log_file
			exit 1
        fi
	else
		echo $error_msg
		echo $error_msg >> $log_file
	fi
}

validate_solr_status