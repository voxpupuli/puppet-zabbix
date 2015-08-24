# class: zabbix::params
#
# this class manages zabbix server parameters
#
# parameters:
#
# actions:
#
# requires:
#
# sample usage:
#
class zabbix::params {
  # It seems that ubuntu has an different fping path...
  case $::operatingsystem {
    'ubuntu': {
        $server_fpinglocation     = '/usr/bin/fping'
        $server_fping6location    = '/usr/bin/fping6'
        $proxy_fpinglocation      = '/usr/bin/fping'
        $proxy_fping6location     = '/usr/bin/fping6'
    }
    default: {
        $server_fpinglocation     = '/usr/sbin/fping'
        $server_fping6location    = '/usr/sbin/fping6'
        $proxy_fpinglocation      = '/usr/sbin/fping'
        $proxy_fping6location     = '/usr/sbin/fping6'
    }
  }

  # Zabbix overall params. Is used by all components.
  $zabbix_version                           = '2.4'
  $zabbix_timezone                          = 'Europe/Amsterdam'
  $zabbix_server                            = 'localhost'
  $zabbix_web                               = 'localhost'
  $zabbix_proxy                             = 'localhost'
  $zabbix_server_ip                         = '127.0.0.1'
  $zabbix_web_ip                            = '127.0.0.1'
  $zabbix_proxy_ip                          = '127.0.0.1'
  $zabbix_package_state                     = 'present'
  $zabbix_template_dir                      = '/etc/zabbix/imported_templates'
  $manage_database                          = true
  $manage_vhost                             = true
  $manage_firewall                          = false
  $manage_repo                              = true
  $manage_resources                         = false
  $database_type                            = 'postgresql'
  $database_schema_path                     = false
  $database_path                            = '/usr/sbin'
  $apache_php_max_execution_time            = '300'
  $apache_php_memory_limit                  = '128M'
  $apache_php_post_max_size                 = '16M'
  $apache_php_upload_max_filesize           = '2M'
  $apache_php_max_input_time                = '300'
  $apache_php_always_populate_raw_post_data = '-1'

  # Zabbix-web
  $apache_use_ssl                 = false
  $apache_ssl_key                 = undef
  $apache_ssl_cert                = undef
  # Cipher is used from: https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility
  # This should be the most current and provide a higher level of security. (Security above everything else)
  $apache_ssl_cipher              = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK'
  $apache_ssl_chain               = undef
  $apache_listen_ip               = undef
  $apache_listenport              = '80'
  $apache_listenport_ssl          = '443'
  $server_api_user                = 'Admin'
  $server_api_pass                = 'zabbix'

  # Zabbix-server
  $server_service_name            = 'zabbix-server'
  $server_configfile_path         = '/etc/zabbix/zabbix_server.conf'
  $server_config_owner            = 'zabbix'
  $server_config_group            = 'zabbix'
  $server_nodeid                  = '0'
  $server_listenport              = '10051'
  $server_sourceip                = undef
  $server_logfile                 = '/var/log/zabbix/zabbix_server.log'
  $server_logfilesize             = '10'
  $server_debuglevel              = '3'
  $server_pidfile                 = '/var/run/zabbix/zabbix_server.pid'
  $server_database_host           = 'localhost'
  $server_database_name           = 'zabbix_server'
  $server_database_schema         = undef
  $server_database_user           = 'zabbix_server'
  $server_database_password       = 'zabbix_server'
  $server_database_socket         = undef
  $server_database_port           = undef
  $server_database_charset        = 'utf8'
  $server_database_collate        = 'utf8_general_ci'
  $server_startpollers            = '5'
  $server_startipmipollers        = '0'
  $server_startpollersunreachable = '1'
  $server_starttrappers           = '5'
  $server_startpingers            = '1'
  $server_startdiscoverers        = '1'
  $server_starthttppollers        = '1'
  $server_starttimers             = '1'
  $server_javagateway             = undef
  $server_javagatewayport         = '10052'
  $server_startjavapollers        = '5'
  $server_startvmwarecollectors   = '0'
  $server_vmwarefrequency         = '60'
  $server_vmwarecachesize         = '8M'
  $server_snmptrapperfile         = '/tmp/zabbix_traps.tmp'
  $server_startsnmptrapper        = '0'
  $server_listenip                = undef
  $server_housekeepingfrequency   = '1'
  $server_maxhousekeeperdelete    = '500'
  $server_senderfrequency         = '30'
  $server_cachesize               = '8M'
  $server_cacheupdatefrequency    = '60'
  $server_startdbsyncers          = '4'
  $server_historycachesize        = '8M'
  $server_trendcachesize          = '4M'
  $server_historytextcachesize    = '16M'
  $server_valuecachesize          = '8M'
  $server_nodenoevents            = '0'
  $server_nodenohistory           = '0'
  $server_timeout                 = '3'
  $server_trappertimeout          = '300'
  $server_unreachableperiod       = '45'
  $server_unavailabledelay        = '60'
  $server_unreachabledelay        = '15'
  $server_alertscriptspath        = '/etc/zabbix/alertscripts'
  $server_externalscripts         = '/usr/lib/zabbix/externalscripts'
  $server_sshkeylocation          = undef
  $server_logslowqueries          = '0'
  $server_tmpdir                  = '/tmp'
  $server_startproxypollers       = '1'
  $server_proxyconfigfrequency    = '3600'
  $server_proxydatafrequency      = '1'
  $server_allowroot               = '0'
  $server_include                 = '/etc/zabbix/zabbix_server.conf.d'
  $server_loadmodulepath          = '/usr/lib/modules'
  $server_loadmodule              = undef

  # Agent specific params
  $agent_configfile_path          = '/etc/zabbix/zabbix_agentd.conf'
  $monitored_by_proxy             = undef
  $agent_use_ip                   = true
  $agent_zbx_group                = 'Linux servers'
  $agent_zbx_group_create         = true
  $agent_zbx_templates            = [ 'Template OS Linux', 'Template App SSH Service' ]
  $agent_pidfile                  = '/var/run/zabbix/zabbix_agentd.pid'
  $agent_logfile                  = '/var/log/zabbix/zabbix_agentd.log'
  $agent_logfilesize              = '100'
  $agent_debuglevel               = '3'
  $agent_sourceip                 = undef
  $agent_enableremotecommands     = '0'
  $agent_logremotecommands        = '0'
  $agent_server                   = '127.0.0.1'
  $agent_listenport               = '10050'
  $agent_listenip                 = undef
  $agent_startagents              = '3'
  $agent_serveractive             = '127.0.0.1'
  $agent_hostname                 = undef
  $agent_hostnameitem             = 'system.hostname'
  $agent_hostmetadata             = undef
  $agent_hostmetadataitem         = undef
  $agent_refreshactivechecks      = '120'
  $agent_buffersend               = '5'
  $agent_buffersize               = '100'
  $agent_maxlinespersecond        = '100'
  $agent_allowroot                = '0'
  $agent_zabbix_alias             = undef
  $agent_timeout                  = '3'
  $agent_include                  = '/etc/zabbix/zabbix_agentd.d'
  $agent_include_purge            = true
  $agent_unsafeuserparameters     = '0'
  $agent_userparameter            = undef
  $agent_loadmodulepath           = '/usr/lib/modules'
  $agent_loadmodule               = undef
  $apache_status                  = false
  # Proxy specific params
  $proxy_hostname                = $::fqdn
  $proxy_service_name            = 'zabbix-proxy'
  $proxy_configfile_path         = '/etc/zabbix/zabbix_proxy.conf'
  $proxy_use_ip                  = true
  $proxy_zbx_templates           = [ 'Template App Zabbix Proxy' ]
  $proxy_mode                    = '0'
  $proxy_zabbix_server_host      = undef
  $proxy_zabbix_server_port      = '10051'
  $proxy_listenport              = '10051'
  $proxy_sourceip                = undef
  $proxy_logfile                 = '/var/log/zabbix/zabbix_proxy.log'
  $proxy_logfilesize             = '10'
  $proxy_debuglevel              = '3'
  $proxy_pidfile                 = '/var/run/zabbix/zabbix_proxy.pid'
  $proxy_database_host           = 'localhost'
  $proxy_database_name           = 'zabbix_proxy'
  $proxy_database_schema         = undef
  $proxy_database_user           = 'zabbix-proxy'
  $proxy_database_password       = 'zabbix-proxy'
  $proxy_database_socket         = undef
  $proxy_database_port           = undef
  $proxy_localbuffer             = '0'
  $proxy_offlinebuffer           = '1'
  $proxy_heartbeatfrequency      = '60'
  $proxy_configfrequency         = '3600'
  $proxy_datasenderfrequency     = '1'
  $proxy_startpollers            = '5'
  $proxy_startipmipollers        = '0'
  $proxy_startpollersunreachable = '1'
  $proxy_starttrappers           = '5'
  $proxy_startpingers            = '1'
  $proxy_startdiscoverers        = '1'
  $proxy_starthttppollers        = '1'
  $proxy_javagateway             = undef
  $proxy_javagatewayport         = '10052'
  $proxy_startjavapollers        = '5'
  $proxy_startvmwarecollectors   = '0'
  $proxy_vmwarefrequency         = '60'
  $proxy_vmwarecachesize         = '8'
  $proxy_snmptrapperfile         = '/tmp/zabbix_traps.tmp'
  $proxy_snmptrapper             = '0'
  $proxy_listenip                = undef
  $proxy_housekeepingfrequency   = '1'
  $proxy_cachesize               = '8'
  $proxy_startdbsyncers          = '4'
  $proxy_historycachesize        = '8'
  $proxy_historytextcachesize    = '16'
  $proxy_timeout                 = '3'
  $proxy_trappertimeout          = '300'
  $proxy_unreachableperiod       = '45'
  $proxy_unavaliabledelay        = '60'
  $proxy_unreachabedelay         = '15'
  $proxy_externalscripts         = '/usr/lib/zabbix/externalscripts'
  $proxy_sshkeylocation          = undef
  $proxy_loglowqueries           = '0'
  $proxy_tmpdir                  = '/tmp'
  $proxy_allowroot               = '0'
  $proxy_include                 = '/etc/zabbix/zabbix_proxy.conf.d'
  $proxy_loadmodulepath          = '/usr/lib/modules'
  $proxy_loadmodule              = undef

  # Java Gateway specific params
  $javagateway_pidfile           = '/var/run/zabbix/zabbix_java.pid'
  $javagateway_listenip          = '0.0.0.0'
  $javagateway_listenport        = '10052'
  $javagateway_startpollers      = '5'
}
