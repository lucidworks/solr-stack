import sys, os, pwd, signal, time
from resource_management import *
from subprocess import call
from resource_management.core.logger import Logger

class Master(Script):

  # Call setup.sh to install the service
  def install(self, env):
  
    # Install packages listed in metainfo.xml
    self.install_packages(env)
    self.configure(env)
    
    # import properties defined in -config.xml file from params class
    import params
    
    find_cmd = 'find ' + params.stack_dir + ' -iname "*.sh" | xargs chmod +x'
    
    Logger.info("Execute: " + find_cmd) 

    # Ensure the shell scripts in the services dir are executable 
    Execute(find_cmd)
        
    # form command to invoke setup.sh with its arguments and execute it
    cmd = params.stack_dir + '/package/scripts/setup.sh ' + params.solr_dir + ' ' + params.solr_downloadlocation + ' ' + params.solr_user + ' >> ' + params.stack_log
    
    Logger.info("Execute: " + cmd) 
    
    Execute(cmd)


  def configure(self, env):
    import params
    env.set_params(params)
    
  def check_zookeeper_status(self):
    import params
    cmd = params.stack_dir + '/package/scripts/check_zk_status.sh ' + params.zookeeper_directory + " " + params.zk_config_dir + " " + params.solr_user + " " + params.zk_cli_shell + " " + params.zk_node1 + " " + params.zk_client_port + " " + params.stack_log
    
    Logger.info("Execute: " + cmd) 
    
    Execute(cmd)

  # Call start.sh to start the service
  def start(self, env):

    # import properties defined in -config.xml file from params class
    import params

    # import status properties defined in -env.xml file from status_params class
    import status_params
    
    # Ensure the shell scripts in the services dir are executable 
    Execute('find ' + params.stack_dir + ' -iname "*.sh" | xargs chmod +x')
    
    # form command to invoke start.sh with its arguments and execute it
    if params.solr_cloudmode:
      self.check_zookeeper_status()
      cmd = params.stack_dir + '/package/scripts/start_cloud.sh ' + params.solr_dir + ' ' + params.stack_log + ' ' + status_params.stack_pidfile + ' ' + params.zookeeper_hosts + ' ' + params.zookeeper_directory + ' ' + params.solr_port 
    else:
      cmd = params.stack_dir + '/package/scripts/start.sh ' + params.solr_dir + ' ' + params.stack_log + ' ' + status_params.stack_pidfile + ' ' + params.solr_port 

      
    Logger.info("Execute: " + cmd)
    
    Execute(cmd)

  # Called to stop the service using the pidfile
  def stop(self, env):
      
    # import properties defined in -config.xml file from params class
    import params
    
    import status_params
    
    cmd = params.stack_dir + '/package/scripts/stop.sh ' + params.solr_dir + ' ' + params.solr_port + ' ' + params.stack_log + ' ' + status_params.stack_pidfile
    
    Logger.info("Execute: " + cmd) 
    
    Execute(cmd)

      	
  # Called to get status of the service using the pidfile
  def status(self, env):
  
    # import status properties defined in -env.xml file from status_params class
    import status_params
        
    env.set_params(status_params)  
    
    # use built-in method to check status using pidfile
    check_process_status(status_params.stack_pidfile)  

if __name__ == "__main__":
  Master().execute()
