#!/usr/bin/env python
from resource_management import *
from ambari_commons import OSCheck
import os

# config object that holds the configurations declared in the -config.xml file
config = Script.get_config()

# store the stack service dir from the 'solr.stack.dir' property of the 'solr-config.xml' file
stack_dir = os.path.realpath(__file__).split('/scripts')[0]

# store the log file for the service from the 'solr.log' property of the 'solr-config.xml' file
stack_log = config['configurations']['solr-config']['solr.log']

solr_cloudmode = config['configurations']['solr-cloud']['solr.cloudmode']
solr_dir = "/opt/lucidworks-hadoop/solr"
solr_user = config['configurations']['solr-config']['solr.user']
solr_port = str(config['configurations']['solr-config']['solr.port'])
zookeeper_directory = config['configurations']['solr-cloud']['solr.cloud.zk.directory']
solr_collection_name = config['configurations']['example-collection']['solr.example']
solr_config_dir = config['configurations']['example-collection']['solr.config.directory']
solr_shards = str(config['configurations']['solr-cloud']['solr.cloud.shards'])
solr_replicas = str(config['configurations']['solr-cloud']['solr.cloud.replicas'])
solr_package_name = "lucidworks-hadoop"
solr_package_name_ubuntu = "lucidworks-hadoop:i386"
solr_deb_file = "lucidworks-hadoop_1-1_i386.deb"
solr_rpm_file = "lucidworks-hadoop-1-1.i386.rpm"
solr_installer_folder_location = "/tmp/"
os_type = OSCheck.get_os_type()

# get comma separated list of zookeeper hosts from clusterHostInfo
zookeeper_hosts = ",".join(config['clusterHostInfo']['zookeeper_hosts'])

# zookeeper
zk_config_dir = "/etc/zookeeper/conf"
zk_cli_shell = format("/usr/hdp/current/zookeeper-server/bin/zkCli.sh")
zk_node1 = config['clusterHostInfo']['zookeeper_hosts'][0];
zk_client_port = str(default('/configurations/zoo.cfg/clientPort', None))

# solr ssl
enable_ssl = config['configurations']['solr-ssl']['solr.enable.ssl']
solr_ssl_key_store = config['configurations']['solr-ssl']['solr.ssl.key.store']
solr_ssl_key_store_password = config['configurations']['solr-ssl']['solr.ssl.key.store.password']
solr_ssl_trust_store = config['configurations']['solr-ssl']['solr.ssl.trust.store']
solr_ssl_trust_store_password = config['configurations']['solr-ssl']['solr.ssl.trust.store.password']
solr_ssl_need_client_auth = config['configurations']['solr-ssl']['solr.ssl.need.client.auth']
solr_ssl_want_client_auth = config['configurations']['solr-ssl']['solr.ssl.want.client.auth']

# HDFS
hdfs_user = config['configurations']['hadoop-env']['hdfs_user']
hadoop_conf_dir = "/etc/hadoop/conf"
hadoop_bin_dir = "/usr/hdp/current/hadoop-client/bin"
fs_default_name = config['configurations']['core-site']['fs.defaultFS']
hdfs_dir = "/solr"