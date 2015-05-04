#!/bin/bash

#Path to install Solr to e.g. /opt/solr
solr_path=$1

#Url to download Solr from
solr_download_location=$2

#solr user e.g. solr
solr_user=$3

function setup_solr(){
	if [ ! -d "$solr_path" ]; then
    	echo "Starting Solr install"
		getent passwd $solr_user
		
		if [ $? -eq 0 ]; then
    		echo "the user exists, no need to create"
		else
	    	echo "creating solr user"
	    	adduser $solr_user
		fi

    	mkdir $solr_path
    	chown $solr_user $solr_path
		hadoop fs -test -d /user/$solr_user
		
		if [ $? -eq 1 ]; then
    		echo "Creating user dir in HDFS"
    		sudo -u hdfs hdfs dfs -mkdir -p /user/$solr_user
    		sudo -u hdfs hdfs dfs -chown $solr_user /user/solr 
		fi
	
		set -e 
    	#download solr tgz and untar it
    	echo "Downloading Solr"
    	cd $solr_path
    	wget $solr_download_location -O solr.tgz
    	tar -xvzf solr.tgz
    	ln -s solr-* latest
    	echo "Solr install complete"
	else
		echo "$solr_path directory already exists. Skipping install...."    	
	fi
}

setup_solr
