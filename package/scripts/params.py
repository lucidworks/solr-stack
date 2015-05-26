#!/usr/bin/env python
from resource_management import *
from ambari_commons import OSCheck
from resource_management.core.logger import Logger
import os

# config object that holds the configurations declared in the -config.xml file
config = Script.get_config()

stack_dir = os.path.realpath(__file__).split('/scripts')[0]
solr_user = "solr"
solr_dir = "/opt/lucidworks-hdpsearch/solr"
solr_package_name = "lucidworks-hdpsearch"
solr_deb_file = "lucidworks-hdpsearch_2.3_all.deb"
solr_rpm_file = "lucidworks-hdpsearch-2.3.noarch.rpm"
solr_installer_folder_location = "/tmp/"
os_type = OSCheck.get_os_type()

map_custom_properties = {};

map_solr_config = config['configurations']['solr-config'];
stack_log = map_solr_config['solr.config.log']
solr_port = str(map_solr_config['solr.config.port'])
solr_memory = map_solr_config['solr.config.memory']
solr_hdfs_enable = map_solr_config['solr.config.hdfs.enable']

for key in map_solr_config:
    value = map_solr_config[key]
    if not key.startswith("solr.config"):
        map_custom_properties[key] = value;

# collection sample
map_example_collection = config['configurations']['example-collection'];
solr_collection_name = map_example_collection['solr.collection.sample.name']
solr_collection_sample_create = map_example_collection['solr.collection.sample.create']
solr_config_dir = map_example_collection['solr.collection.sample.config.directory']
solr_shards = str(map_example_collection['solr.collection.sample.shards'])
solr_replicas = str(map_example_collection['solr.collection.sample.replicas'])

for key in map_example_collection:
    value = map_example_collection[key]
    if not key.startswith("solr.collection.sample"):
        map_custom_properties[key] = value;

# solr cloud
map_solr_cloud = config['configurations']['solr-cloud'];
zookeeper_directory = map_solr_cloud['solr.cloud.zk.directory']
solr_cloudmode = map_solr_cloud['solr.cloud.enable']

for key in map_solr_cloud:
    value = map_solr_cloud[key]
    if not key.startswith("solr.cloud"):
        map_custom_properties[key] = value;
        
# zookeeper
zk_config_dir = "/etc/zookeeper/conf"
zk_cli_shell = format("/usr/hdp/current/zookeeper-server/bin/zkCli.sh")
zk_node1 = config['clusterHostInfo']['zookeeper_hosts'][0];
zk_client_port = str(default('/configurations/zoo.cfg/clientPort', None))

hosts = config['clusterHostInfo']['zookeeper_hosts']
hosts_length = len(hosts)
zookeeper_hosts = ""

for i, val in enumerate(hosts):
    zookeeper_hosts += val + ":" + zk_client_port
    
    if (i + 1) < hosts_length:
        zookeeper_hosts += ","

# solr ssl
map_solr_ssl = config['configurations']['solr-ssl'];
enable_ssl = map_solr_ssl['solr.ssl.enable']
solr_ssl_key_store = map_solr_ssl['solr.ssl.key.store']
solr_ssl_key_store_password = map_solr_ssl['solr.ssl.key.store.password']
solr_ssl_trust_store = map_solr_ssl['solr.ssl.trust.store']
solr_ssl_trust_store_password = map_solr_ssl['solr.ssl.trust.store.password']
solr_ssl_need_client_auth = map_solr_ssl['solr.ssl.need.client.auth']
solr_ssl_want_client_auth = map_solr_ssl['solr.ssl.want.client.auth']

for key in map_solr_ssl:
    value = map_solr_ssl[key]
    if not key.startswith("solr.ssl"):
        map_custom_properties[key] = value;

# HDFS
hdfs_user = config['configurations']['hadoop-env']['hdfs_user']
hadoop_conf_dir = "/etc/hadoop/conf"
hadoop_bin_dir = "/usr/hdp/current/hadoop-client/bin"
fs_default_name = config['configurations']['core-site']['fs.defaultFS']
hdfs_dir = "/solr"
