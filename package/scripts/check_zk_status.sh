#!/bin/bash

zk_directory=$1
config_dir=$2
solr_user=$3
zk_cli_shell=$4
zk_node1=$5
client_port=$6
log_file=$7
test_connection_file=/tmp/zk_test_connection.log
test_file_exists=/tmp/zk_test_file_exists.log
create_file_output=/tmp/zk_create_folder.log

function check_zk_output() {
	/var/lib/ambari-agent/ambari-sudo.sh su $solr_user -s /bin/bash - -c "source $config_dir/zookeeper-env.sh ; echo 'ls /' | ${zk_cli_shell} -server $zk_node1:$client_port" 2>&1> $test_connection_file

	if [ -f $test_connection_file ]; then
		grep "CONNECTED" $test_connection_file
		
        if [ "$?" -eq 1 ]; then
        	error_msg="Error: ZooKeeper is not running"
			echo $error_msg
			echo $error_msg >> $log_file
			exit 1
		fi

		output=$(/var/lib/ambari-agent/ambari-sudo.sh su $solr_user -s /bin/bash - -c "source $config_dir/zookeeper-env.sh ; echo 'get $zk_directory' | ${zk_cli_shell} -server $zk_node1:$client_port")
		echo $output | grep "get $zk_directory solr_cloud_node"

		if [ "$?" -eq 1 ]; then
			/var/lib/ambari-agent/ambari-sudo.sh su $solr_user -s /bin/bash - -c "source $config_dir/zookeeper-env.sh ; echo 'create $zk_directory solr_cloud_node' | ${zk_cli_shell} -server $zk_node1:$client_port"
		else
			error_msg="The $zk_directory directory already exists"
			echo $error_msg
			echo $error_msg >> $log_file
		fi
	fi
}

check_zk_output