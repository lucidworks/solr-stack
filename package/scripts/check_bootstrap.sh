#!/bin/bash

zk_directory=$1
config_dir=$2
solr_user=$3
zk_cli_shell=$4
zk_node1=$5
client_port=$6
collection_name=$7
log_file=$8

function check_bootstrap() {
	output=$(/var/lib/ambari-agent/ambari-sudo.sh su $solr_user -s /bin/bash - -c "source $config_dir/zookeeper-env.sh ; echo 'get $zk_directory/configs/$collection_name' | ${zk_cli_shell} -server $zk_node1:$client_port")
	echo $output | grep "get $zk_directory/configs/$collection_name null"
	
	if [ "$?" -eq 1 ]; then
		error_msg="Unsuccessful bootstrap, the collection $collection_name does not exist"
		echo $error_msg
		echo $error_msg >> $log_file
		exit 1
	fi
}

check_bootstrap