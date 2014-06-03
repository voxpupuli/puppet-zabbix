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
  # Zabbix overall params
  $dbtype                         = 'postgresql'
  $zabbix_version                 = '2.2'
  $zabbix_timezone                = 'Europe/Amsterdam'
  $manage_database                = true
  $manage_vhost                   = true
  $manage_firewall                = false
  $manage_repo                    = true

  # Server specific params
  $server_nodeid                  = '0'
  $server_listenport              = '10051'
  $server_sourceip                = undef
  $server_logfile                 = '/var/log/zabbix/zabbix_server.log'
  $server_logfilesize             = '10'
  $server_debuglevel              = '3'
  $server_pidfile                 = '/var/run/zabbix/zabbix_server.pid'
  $server_dbhost                  = 'localhost'
  $server_dbname                  = 'zabbix-server'
  $server_dbschema                = undef
  $server_dbuser                  = 'zabbix-server'
  $server_dbpassword              = 'zabbix-server'
  $server_dbsocket                = undef
  $server_dbport                  = undef
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
  $server_alertscriptspath        = '${datadir}/zabbix/alertscripts'
  $server_externalscripts         = '/usr/lib/zabbix/externalscripts'
  $server_fpinglocation           = '/usr/sbin/fping'
  $server_fping6location          = '/usr/sbin/fping6'
  $server_sshkeylocation          = undef
  $server_logslowqueries          = '0'
  $server_tmpdir                  = '/tmp'
  $server_startproxypollers       = '1'
  $server_proxyconfigfrequency    = '3600'
  $server_proxydatafrequency      = '1'
  $server_allowroot               = '0'
  $server_include                 = '/etc/zabbix/zabbix_server.conf.d'
  $server_loadmodulepath          = '${libdir}/modules'
  $server_loadmodule              = undef

  # Agent specific params
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
  $agent_hostname                 = $::fqdn
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
  $agent_unsafeuserparameters     = '0'
  $agent_userparameter            = undef
  $agent_loadmodulepath           = '${libdir}/modules'
  $agent_loadmodule               = undef

  # Proxy specific params
  $proxy_mode                    = '0'
  $proxy_zabbix_server_host      = undef
  $proxy_zabbix_server_port      = '10051'
  $proxy_listenport              = '10051'
  $proxy_sourceip                = undef
  $proxy_logfile                 = '/var/log/zabbix/proxy_server.log'
  $proxy_logfilesize             = '10'
  $proxy_debuglevel              = '3'
  $proxy_pidfile                 = '/var/run/zabbix/proxy_server.pid'
  $proxy_dbhost                  = 'localhost'
  $proxy_dbname                  = 'zabbix-proxy'
  $proxy_dbschema                = undef
  $proxy_dbuser                  = 'zabbix-proxy'
  $proxy_dbpassword              = 'zabbix-proxy'
  $proxy_dbsocket                = undef
  $proxy_dbport                  = undef
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
  $proxy_startvmwarecollector    = '0'
  $proxy_vmwarefrequency         = '60'
  $proxy_vmwarecachesize         = '8'
  $proxy_snmptrapperfile         = '/tmp/zabbix_traps.tmp'
  $proxy_snmptrapper             = '0'
  $proxy_listenip                = undef
  $proxy_housekeepingfrequency   = '1'
  $proxy_casesize                = '8'
  $proxy_startdbsyncers          = '4'
  $proxy_historycachesize        = '8'
  $proxy_historytextcachesize    = '16'
  $proxy_timeout                 = '3'
  $proxy_trappertimeout          = '300'
  $proxy_unreachableperiod       = '45'
  $proxy_unavaliabledelay        = '60'
  $proxy_unreachabedelay         = '15'
  $proxy_externalscripts         = '/usr/lib/zabbix/externalscripts'
  $proxy_fpinglocation           = '/usr/sbin/fping'
  $proxy_fping6location          = '/usr/sbin/fping6'
  $proxy_sshkeylocation          = undef
  $proxy_loglowqueries           = '0'
  $proxy_tmpdir                  = '/tmp'
  $proxy_allowroot               = '0'
  $proxy_include                 = '/etc/zabbix/zabbix_proxy.conf.d'
  $proxy_loadmodulepath          = '${libdir}/modules'
  $proxy_loadmodule              = undef

  # Java Gateway specific params
  $javagateway_pidfile           = '/var/run/zabbix/zabbix_java.pid'
  $javagateway_listenip          = '0.0.0.0'
  $javagateway_listenport        = '10052'
  $javagateway_startpollers      = '5'
}
