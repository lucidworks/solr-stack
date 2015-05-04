#!/bin/bash

#Path to start.jar e.g. /opt/solr
solr_path=$1

#log_file e.g. /var/log/solr.log
log_file=$2

#pid file e.g. /var/run/solr.pid
pid_file=$3

#zookeeper hosts
zk_hosts=$4

zk_directory=$5

solr_port=$6

echo "Found zookeepers on : $zk_hosts"  >> $log_file	
 
pid_dir=$(dirname "$pid_file")

function validate_pid_dir() {
	if [ ! -d "$pid_dir" ]; then
		echo "Creating pid_dir: $pid_dir"
		mkdir -p $pid_dir
	fi
}

function validate_node_status() {
	if [ -f "$pid_file" ]; then
		output=$(./solr status)
		echo $output | grep "No Solr nodes are running."
		
		if [ "$?" -eq 1 ]; then
			error_msg="Solr is running, it cannot be started again"
			echo $error_msg
			echo $error_msg >> $log_file
			exit 1
        fi
	fi
}

function validate_solr_port() {
	output=$(netstat -lnt | awk -v v1=$solr_port '$6 == "LISTEN" && $4 ~ ":"+v1')
	echo $output | grep "LISTEN"
	
	if [ "$?" -eq 0 ]; then
		error_msg="The port $solr_port is not available"
		echo $error_msg
		echo $error_msg >> $log_file
		exit 1
    fi
}

function start_solr() {
	echo "Starting Solr..." >> $log_file
	output=`./solr start -p $solr_port`
	echo $output >> $log_file
	pid=`echo $output | sed -e 's/.*pid=\(.*\)).*/\1/'`
	echo $pid > $pid_file
}

function start_solr_cloud(){
	echo "Starting Solr Cloud..." >> $log_file
	echo "Zookeeper ensemble $zk_hosts$zk_directory" >> $log_file
	output=`./solr start -cloud -z $zk_hosts$zk_directory -p $solr_port`
	echo $output >> $log_file	
	pid=`echo $output | sed -e 's/.*pid=\(.*\)).*/\1/'`
	echo $pid > $pid_file
}

validate_pid_dir

cd $solr_path/latest/bin

validate_node_status
validate_solr_port
start_solr_cloud