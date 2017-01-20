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
    'ubuntu', 'debian' : {
      $server_fpinglocation  = '/usr/bin/fping'
      $server_fping6location = '/usr/bin/fping6'
      $proxy_fpinglocation   = '/usr/bin/fping'
      $proxy_fping6location  = '/usr/bin/fping6'
      $manage_repo           = true
      $zabbix_package_agent  = 'zabbix-agent'
      $agent_configfile_path = '/etc/zabbix/zabbix_agentd.conf'
    }
    'Archlinux': {
      $server_fpinglocation  = '/usr/bin/fping'
      $server_fping6location = '/usr/bin/fping6'
      $proxy_fpinglocation   = '/usr/bin/fping'
      $proxy_fping6location  = '/usr/bin/fping6'
      $manage_repo           = false
      $zabbix_package_agent  = 'zabbix3-agent'
      $agent_configfile_path = '/etc/zabbix/zabbix_agentd.conf'

    }
    'Fedora': {
      $server_fpinglocation  = '/usr/sbin/fping'
      $server_fping6location = '/usr/sbin/fping6'
      $proxy_fpinglocation   = '/usr/sbin/fping'
      $proxy_fping6location  = '/usr/sbin/fping6'
      $manage_repo           = false
      $zabbix_package_agent  = 'zabbix-agent'
      $agent_configfile_path = '/etc/zabbix_agentd.conf'
    }
    default  : {
      $server_fpinglocation  = '/usr/sbin/fping'
      $server_fping6location = '/usr/sbin/fping6'
      $proxy_fpinglocation   = '/usr/sbin/fping'
      $proxy_fping6location  = '/usr/sbin/fping6'
      $manage_repo           = true
      $zabbix_package_agent  = 'zabbix-agent'
      $agent_configfile_path = '/etc/zabbix/zabbix_agentd.conf'
    }
  }

  # Zabbix overall params. Is used by all components.
  $zabbix_package_state                     = 'present'
  $zabbix_proxy                             = 'localhost'
  $zabbix_proxy_ip                          = '127.0.0.1'
  $zabbix_server                            = 'localhost'
  $zabbix_server_ip                         = '127.0.0.1'
  $zabbix_template_dir                      = '/etc/zabbix/imported_templates'
  $zabbix_timezone                          = 'Europe/Amsterdam'
  $zabbix_url                               = 'localhost'
  $zabbix_version                           = '3.0'
  $zabbix_web                               = 'localhost'
  $zabbix_web_ip                            = '127.0.0.1'
  $manage_database                          = true
  $manage_service                           = true
  $default_vhost                            = false
  $manage_firewall                          = false
  $repo_location                            = ''
  $manage_resources                         = false
  $manage_vhost                             = true
  $database_path                            = '/usr/sbin'
  $database_schema_path                     = false
  $database_type                            = 'postgresql'
  $apache_php_always_populate_raw_post_data = '-1'
  $apache_php_max_execution_time            = '300'
  $apache_php_max_input_time                = '300'
  $apache_php_max_input_vars                = 1000
  $apache_php_memory_limit                  = '128M'
  $apache_php_post_max_size                 = '16M'
  $apache_php_upload_max_filesize           = '2M'

  # Zabbix-web
  $apache_listen_ip                         = undef
  $apache_listenport                        = '80'
  $apache_listenport_ssl                    = '443'
  $apache_ssl_cert                          = undef
  $apache_ssl_chain                         = undef
  # Cipher is used from: https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility
  # This should be the most current and provide a higher level of security. (Security above everything else)
  $apache_ssl_cipher                        = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK'
  $apache_ssl_key                           = undef
  $apache_use_ssl                           = false
  $ldap_cacert                              = undef
  $ldap_clientcert                          = undef
  $ldap_clientkey                           = undef
  $server_api_pass                          = 'zabbix'
  $server_api_user                          = 'Admin'

  # Zabbix-server
  $server_alertscriptspath                  = '/etc/zabbix/alertscripts'
  $server_allowroot                         = '0'
  $server_cachesize                         = '8M'
  $server_cacheupdatefrequency              = '60'
  $server_config_group                      = 'zabbix'
  $server_config_owner                      = 'zabbix'
  $server_configfile_path                   = '/etc/zabbix/zabbix_server.conf'
  $server_database_charset                  = 'utf8'
  $server_database_collate                  = 'utf8_general_ci'
  $server_database_host                     = 'localhost'
  $server_database_name                     = 'zabbix_server'
  $server_database_password                 = 'zabbix_server'
  $server_database_port                     = undef
  $server_database_schema                   = undef
  $server_database_socket                   = undef
  $server_database_user                     = 'zabbix_server'
  $server_debuglevel                        = '3'
  $server_externalscripts                   = '/usr/lib/zabbix/externalscripts'
  $server_historycachesize                  = '8M'
  $server_historyindexcachesize             = undef
  $server_historytextcachesize              = '16M'
  $server_housekeepingfrequency             = '1'
  $server_include                           = '/etc/zabbix/zabbix_server.conf.d'
  $server_javagateway                       = undef
  $server_javagatewayport                   = '10052'
  $server_listenip                          = undef
  $server_listenport                        = '10051'
  $server_loadmodule                        = undef
  $server_loadmodulepath                    = '/usr/lib/modules'
  $server_logfile                           = '/var/log/zabbix/zabbix_server.log'
  $server_logfilesize                       = '10'
  $server_logslowqueries                    = '0'
  $server_maxhousekeeperdelete              = '500'
  $server_nodeid                            = '0'
  $server_nodenoevents                      = '0'
  $server_nodenohistory                     = '0'
  $server_pidfile                           = '/var/run/zabbix/zabbix_server.pid'
  $server_proxyconfigfrequency              = '3600'
  $server_proxydatafrequency                = '1'
  $server_senderfrequency                   = '30'
  $server_service_name                      = 'zabbix-server'
  $server_pacemaker                         = false
  $server_pacemaker_resource                = undef
  $server_snmptrapperfile                   = '/tmp/zabbix_traps.tmp'
  $server_sourceip                          = undef
  $server_sshkeylocation                    = undef
  $server_sslcertlocation                   = '/usr/lib/zabbix/ssl/certs'
  $server_sslkeylocation                    = '/usr/lib/zabbix/ssl/keys'
  $server_startdbsyncers                    = '4'
  $server_startdiscoverers                  = '1'
  $server_starthttppollers                  = '1'
  $server_startipmipollers                  = '0'
  $server_startjavapollers                  = '5'
  $server_startpingers                      = '1'
  $server_startpollers                      = '5'
  $server_startpollersunreachable           = '1'
  $server_startproxypollers                 = '1'
  $server_startsnmptrapper                  = '0'
  $server_starttimers                       = '1'
  $server_starttrappers                     = '5'
  $server_startvmwarecollectors             = '0'
  $server_timeout                           = '3'
  $server_tlscafile                         = undef
  $server_tlscertfile                       = undef
  $server_tlscrlfile                        = undef
  $server_tlskeyfile                        = undef
  $server_tmpdir                            = '/tmp'
  $server_trappertimeout                    = '300'
  $server_trendcachesize                    = '4M'
  $server_unavailabledelay                  = '60'
  $server_unreachabledelay                  = '15'
  $server_unreachableperiod                 = '45'
  $server_valuecachesize                    = '8M'
  $server_vmwarecachesize                   = '8M'
  $server_vmwarefrequency                   = '60'

  # Agent specific params
  $agent_allowroot                          = '0'
  $agent_zabbix_user                        = undef
  $agent_buffersend                         = '5'
  $agent_buffersize                         = '100'
  $agent_debuglevel                         = '3'
  $agent_enableremotecommands               = '0'
  $agent_hostmetadata                       = undef
  $agent_hostmetadataitem                   = undef
  $agent_hostname                           = undef
  $agent_hostnameitem                       = 'system.hostname'
  $agent_include                            = '/etc/zabbix/zabbix_agentd.d'
  $agent_include_purge                      = true
  $agent_listenip                           = undef
  $agent_listenport                         = '10050'
  $agent_loadmodule                         = undef
  $agent_loadmodulepath                     = '/usr/lib/modules'
  $agent_logtype                            = 'file'
  $agent_logfile                            = '/var/log/zabbix/zabbix_agentd.log'
  $agent_logfilesize                        = '100'
  $agent_logremotecommands                  = '0'
  $agent_maxlinespersecond                  = '100'
  $agent_pidfile                            = '/var/run/zabbix/zabbix_agentd.pid'
  $agent_refreshactivechecks                = '120'
  $agent_server                             = '127.0.0.1'
  $agent_serveractive                       = undef
  $agent_sourceip                           = undef
  $agent_startagents                        = '3'
  $agent_timeout                            = '3'
  $agent_tlsaccept                          = undef
  $agent_tlscafile                          = undef
  $agent_tlscertfile                        = undef
  $agent_tlsconnect                         = undef
  $agent_tlscrlfile                         = undef
  $agent_tlskeyfile                         = undef
  $agent_tlspskfile                         = undef
  $agent_tlspskidentity                     = undef
  $agent_tlsservercertissuer                = undef
  $agent_tlsservercertsubject               = undef
  $agent_unsafeuserparameters               = '0'
  $agent_use_ip                             = true
  $agent_userparameter                      = undef
  $agent_zabbix_alias                       = undef
  $agent_zbx_group                          = 'Linux servers'
  $agent_zbx_group_create                   = true
  $agent_zbx_templates                      = [
    'Template OS Linux',
    'Template App SSH Service']
  $apache_status                            = false
  $monitored_by_proxy                       = undef

  # Proxy specific params
  $proxy_allowroot                          = '0'
  $proxy_cachesize                          = '8M'
  $proxy_configfile_path                    = '/etc/zabbix/zabbix_proxy.conf'
  $proxy_configfrequency                    = '3600'
  $proxy_database_host                      = 'localhost'
  $proxy_database_name                      = 'zabbix_proxy'
  $proxy_database_password                  = 'zabbix-proxy'
  $proxy_database_port                      = undef
  $proxy_database_schema                    = undef
  $proxy_database_socket                    = undef
  $proxy_database_user                      = 'zabbix-proxy'
  $proxy_datasenderfrequency                = '1'
  $proxy_debuglevel                         = '3'
  $proxy_externalscripts                    = '/usr/lib/zabbix/externalscripts'
  $proxy_heartbeatfrequency                 = '60'
  $proxy_historycachesize                   = '8M'
  $proxy_historyindexcachesize              = undef
  $proxy_historytextcachesize               = '16M'
  $proxy_hostname                           = $::fqdn
  $proxy_housekeepingfrequency              = '1'
  $proxy_include                            = '/etc/zabbix/zabbix_proxy.conf.d'
  $proxy_javagateway                        = undef
  $proxy_javagatewayport                    = '10052'
  $proxy_listenip                           = undef
  $proxy_listenport                         = '10051'
  $proxy_loadmodule                         = undef
  $proxy_loadmodulepath                     = '/usr/lib/modules'
  $proxy_localbuffer                        = '0'
  $proxy_logfile                            = '/var/log/zabbix/zabbix_proxy.log'
  $proxy_logfilesize                        = '10'
  $proxy_logslowqueries                     = '0'
  $proxy_mode                               = '0'
  $proxy_offlinebuffer                      = '1'
  $proxy_pidfile                            = '/var/run/zabbix/zabbix_proxy.pid'
  $proxy_service_name                       = 'zabbix-proxy'
  $proxy_enablesnmpbulkrequests             = undef
  $proxy_snmptrapper                        = '0'
  $proxy_snmptrapperfile                    = '/tmp/zabbix_traps.tmp'
  $proxy_sourceip                           = undef
  $proxy_sshkeylocation                     = undef
  $proxy_startdbsyncers                     = '4'
  $proxy_startdiscoverers                   = '1'
  $proxy_starthttppollers                   = '1'
  $proxy_startipmipollers                   = '0'
  $proxy_startjavapollers                   = '5'
  $proxy_startpingers                       = '1'
  $proxy_startpollers                       = '5'
  $proxy_startpollersunreachable            = '1'
  $proxy_starttrappers                      = '5'
  $proxy_startvmwarecollectors              = '0'
  $proxy_timeout                            = '3'
  $proxy_tlsaccept                          = undef
  $proxy_tlscafile                          = undef
  $proxy_tlscertfile                        = undef
  $proxy_tlsconnect                         = undef
  $proxy_tlscrlfile                         = undef
  $proxy_tlskeyfile                         = undef
  $proxy_tlspskfile                         = undef
  $proxy_tlspskidentity                     = undef
  $proxy_tlsservercertissuer                = undef
  $proxy_tlsservercertsubject               = undef
  $proxy_tmpdir                             = '/tmp'
  $proxy_trappertimeout                     = '300'
  $proxy_unavaliabledelay                   = '60'
  $proxy_unreachabedelay                    = '15'
  $proxy_unreachableperiod                  = '45'
  $proxy_use_ip                             = true
  $proxy_vmwarecachesize                    = '8M'
  $proxy_vmwarefrequency                    = '60'
  $proxy_vmwareperffrequency                = undef
  $proxy_vmwaretimeout                      = undef
  $proxy_zabbix_server_host                 = undef
  $proxy_zabbix_server_port                 = '10051'
  $proxy_zbx_templates                      = ['Template App Zabbix Proxy']

  # Java Gateway specific params
  $javagateway_listenip                     = '0.0.0.0'
  $javagateway_listenport                   = '10052'
  $javagateway_pidfile                      = '/var/run/zabbix/zabbix_java.pid'
  $javagateway_startpollers                 = '5'
  $javagateway_timeout                      = '3'

  # Gem provider may vary based on version/type of puppet install.
  # This can be a little complicated and may need revisited over time.
  if str2bool($::is_pe) {
    if $::pe_version and versioncmp("${::pe_version}", '3.7.0') >= 0 { # lint:ignore:only_variable_string
      $puppetgem = 'pe_puppetserver_gem'
    } else {
      $puppetgem = 'pe_gem'
    }
  } else {
    if $::puppetversion and versioncmp($::puppetversion, '4.0.0') >= 0 {
      $puppetgem = 'puppet_gem'
    } else {
      $puppetgem = 'gem'
    }
  }

  $default_web_config_owner = $::operatingsystem ? {
    /(Ubuntu|Debian)/ => 'www-data',
    default           => 'apache',
  }

  $_web_config_owner = getvar('::apache::user')
  if $_web_config_owner {
    if $_web_config_owner =~ /^\S+$/ {
      # One or more non-whitespace chars
      $web_config_owner = $_web_config_owner
    } else {
      # Empty string or contains whitespace (stdlib < 4.13.0 bug)
      $web_config_owner = $default_web_config_owner
    }
  } else {
    # getvar returned undef
    $web_config_owner = $default_web_config_owner
  }

  $_web_config_group = getvar('::apache::group')
  if $_web_config_group {
    if $_web_config_group =~ /^\S+$/ {
      $web_config_group = $_web_config_group
    } else {
      $web_config_group = $default_web_config_owner
    }
  } else {
    # getvar returned undef
    $web_config_group = $default_web_config_owner
  }
}
