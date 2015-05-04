#!/usr/bin/env python
from resource_management import *

# config object that holds the configurations declared in the -config.xml file
config = Script.get_config()

# store the stack service dir from the 'solr.stack.dir' property of the 'solr-config.xml' file
stack_dir = config['configurations']['solr-config']['solr.stack.dir']

# store the log file for the service from the 'solr.log' property of the 'solr-config.xml' file
stack_log = config['configurations']['solr-config']['solr.log']

solr_cloudmode = config['configurations']['solr-config']['solr.cloudmode']
solr_dir = config['configurations']['solr-config']['solr.dir']
solr_downloadlocation = config['configurations']['solr-config']['solr.download.location']
solr_user = config['configurations']['solr-config']['solr.user']
solr_port = str(config['configurations']['solr-config']['solr.port'])
zookeeper_directory = config['configurations']['solr-cloud']['solr.cloud.zk.directory']
solr_collection_name = config['configurations']['solr-config']['solr.example']
solr_config_dir = config['configurations']['solr-config']['solr.config.directory']
solr_shards = str(config['configurations']['solr-cloud']['solr.cloud.shards'])
solr_replicas = str(config['configurations']['solr-cloud']['solr.cloud.replicas'])


# get comma separated list of zookeeper hosts from clusterHostInfo
zookeeper_hosts = ",".join(config['clusterHostInfo']['zookeeper_hosts'])

# zookeeper
zk_config_dir = "/etc/zookeeper/conf"
zk_cli_shell = format("/usr/hdp/current/zookeeper-server/bin/zkCli.sh")
zk_node1 = config['clusterHostInfo']['zookeeper_hosts'][0];
zk_client_port = str(default('/configurations/zoo.cfg/clientPort', None))
