from resource_management.core.resources.system import Execute, File
from resource_management.libraries.functions.format import format
from resource_management.core.source import Template
from resource_management.core.shell import call


def setup_solr_kerberos_auth():
    import params

    File(format("{solr_kerberos_jaas_config}"),
         content=Template("solr_server_jaas.conf.j2"),
         owner=params.solr_config_user
         )

    if not params.solr_cloud_mode:
        return

    # TODO LWSHADOOP-637 add json in the config file and only upload it when kerberos is enable
    command = format('{zk_client_prefix} -cmd put {solr_cloud_zk_directory}{security_json} ')
    command += '\'{"authentication":{"class": "org.apache.solr.security.KerberosPlugin"}}\''
    Execute(command,
            environment={'JAVA_HOME': params.java64_home},
            ignore_failures=True,
            user=params.solr_config_user
            )


def remove_solr_kerberos_auth():
    import params

    if not params.solr_cloud_mode:
        return

    code, output = call(format('{zk_client_prefix} -cmd get {solr_cloud_zk_directory}{security_json}'),
                        env={'JAVA_HOME': params.java64_home},
                        timeout=60
                        )

    if "NoNodeException" in output:
        return

    Execute(format('{zk_client_prefix} -cmd clear {solr_cloud_zk_directory}{security_json}'),
            environment={'JAVA_HOME': params.java64_home},
            timeout=60,
            ignore_failures=True,
            user=params.solr_config_user
            )
