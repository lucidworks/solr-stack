#!/usr/bin/env python

from resource_management.libraries.script import Script
from resource_management.core.logger import Logger
from resource_management import *

class ServiceCheck(Script):
    def check_solr_status(self):
        import params
        
        import status_params
        
        cmd = params.stack_dir + '/scripts/check_solr_status.sh ' + params.solr_dir + " " + status_params.stack_pidfile + " " + params.solr_port + " >> " + params.stack_log
        
        Logger.info("Execute: " + cmd) 
        
        Execute(cmd)
        
    def create_example(self):
        import params
        
        Logger.info("Create example collection")
        
        if params.solr_cloudmode:
            cmd = params.stack_dir + '/scripts/create_solr_cloud_example.sh ' + params.solr_dir + ' ' + params.solr_collection_name + ' ' + params.solr_config_dir + ' ' + params.solr_port + ' ' + params.solr_shards + ' ' + params.solr_replicas + ' >> ' + params.stack_log 
        else:
            cmd = params.stack_dir + '/scripts/create_solr_example.sh ' + params.solr_dir + ' ' + params.solr_collection_name + ' ' + params.solr_config_dir + ' ' + params.solr_port + ' >> ' + params.stack_log
            
        Logger.info("Execute: " + cmd)
            
        Execute(cmd) 
        
    def check_bootstrap(self):
        import params
        
        cmd = params.stack_dir + '/scripts/check_bootstrap.sh ' + params.zookeeper_directory + " " + params.zk_config_dir + " " + params.solr_user + " " + params.zk_cli_shell + " " + params.zk_node1 + " " + params.zk_client_port + " " + params.solr_collection_name + " >> " + params.stack_log
        
        Logger.info("Execute: " + cmd)
        
        Execute(cmd)
    
    def service_check(self, env):
        import params

        self.check_solr_status()
        self.create_example()
        
        if params.solr_cloudmode:
            self.check_bootstrap()

if __name__ == "__main__":
    ServiceCheck().execute()