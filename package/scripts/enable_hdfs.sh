#!/bin/bash

HDFS_DIR=$1
HADOOP_BIN_DIR=$2
HADOOP_CONF_DIR=$3

/var/lib/ambari-agent/ambari-sudo.sh su hdfs -l -s /bin/bash -c "$HADOOP_BIN_DIR/hadoop --config $HADOOP_CONF_DIR dfsadmin -safemode get | grep OFF"
/var/lib/ambari-agent/ambari-sudo.sh su hdfs -l -s /bin/bash -c "$HADOOP_BIN_DIR/hadoop --config $HADOOP_CONF_DIR fs -test -e $HDFS_DIR"

if [ "$?" -eq 1 ]; then
    /var/lib/ambari-agent/ambari-sudo.sh su hdfs -l -s /bin/bash -c "$HADOOP_BIN_DIR/hadoop --config $HADOOP_CONF_DIR fs -mkdir $HDFS_DIR"
    /var/lib/ambari-agent/ambari-sudo.sh su hdfs -l -s /bin/bash -c "$HADOOP_BIN_DIR/hadoop --config $HADOOP_CONF_DIR fs -chmod 777 $HDFS_DIR"
    echo "The directory $HDFS_DIR was successfully created"
else
    echo "The directory $HDFS_DIR already exists"
fi