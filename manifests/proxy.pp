# == Class: zabbix::proxy
#
#  This will install and configure the zabbix-agent deamon
#
# === Requirements
#
# When 'manage_database' is set to true, the corresponding database class
# in 'dbtype' should be required.
#
# === Parameters
#
# [*dbtype*]
#   Type of database. Can use the following 3 databases:
#   - postgresql
#   - mysql
#   - sqlite
#
# [*zabbix_version*]
#   This is the zabbix version.
#
# [*manage_database*]
#   When true, it will configure the database and execute the sql scripts.
#
# [*manage_firewall*]
#   When true, it will create iptables rules.
#
# [*manage_repo*]
#   When true, it will create repository for installing the proxy.
#
# [*manage_resources*]
#   When true, it will export resources so that the zabbix-server can create
#   via the zabbix-api proxy.
#
# [*use_ip*]
#   When true, when creating proxies via the zabbix-api, it will configure that
#   connection should me made via ip, not fqdn.
#
# [*zbx_templates*]
#   Template which will be added when proxy is configured.
#
# [*mode*]
#   Proxy operating mode.
#
# [*zabbix_server_host*]
#   Hostname or the ipaddress of the zabbix-server.
#
# [*zabbix_server_port*]
#   Port on which the server is listening.
#
# [*listenport*]
#   Listen port for trapper.
#
# [*sourceip*]
#   Source ip address for outgoing connections.
#
# [*logfile*]
#   Name of log file.
#
# [*logfilesize*]
#   Maximum size of log file in MB.
#
# [*debuglevel*]
#   Specifies debug level.
#
# [*pidfile*]
#   Name of pid file.
#
# [*dbhost*]
#   Database host name.
#
# [*dbname*]
#   Database name.
#
# [*dbschema*]
#   Schema name. used for ibm db2.
#
# [*dbuser*]
#   Database user. ignored for sqlite.
#
# [*dbpassword*]
#   Database password. ignored for sqlite.
#
# [*dbsocket*]
#   Path to mysql socket.
#
# [*dbport*]
#   Database port when not using local socket. Ignored for sqlite.
#
# [*localbuffer*]
#   Proxy will keep data locally for N hours, even if the data have already been synced with the server
#
# [*offlinebuffer*]
#   Proxy will keep data for N hours in case if no connectivity with Zabbix Server
#
# [*heartbeatfrequency*]
#   Unique nodeid in distributed setup.
#
# [*configfrequency*]
#   Unique nodeid in distributed setup.
#
# [*datasenderfrequency*]
#   Proxy will send collected data to the Server every N seconds.
#
# [*startpollers*]
#   Number of pre-forked instances of pollers.
#
# [*startipmipollers*]
#   Number of pre-forked instances of ipmi pollers.
#
# [*startpollersunreachable*]
#   Number of pre-forked instances of pollers for unreachable hosts (including ipmi).
#
# [*starttrappers*]
#   Number of pre-forked instances of trappers.
#
# [*startpingers*]
#   Number of pre-forked instances of icmp pingers.
#
# [*startdiscoverers*]
#   Number of pre-forked instances of discoverers.
#
# [*starthttppollers*]
#   Number of pre-forked instances of http pollers.
#
# [*javagateway_host*]
#   IP address (or hostname) of zabbix java gateway.
#
# [*javagateway_port*]
#   Port that zabbix java gateway listens on.
#
# [*startjavapollers*]
#   Number of pre-forked instances of java pollers.
#
# [*startvmwarecollectors*]
#   Number of pre-forked vmware collector instances.
#
# [*vmwarefrequency*]
#   How often zabbix will connect to vmware service to obtain a new datan.
#
# [*vmwarecachesize*]
#   Size of vmware cache, in bytes.
#
# [*snmptrapperfile*]
#   Temporary file used for passing data from snmp trap daemon to the server.
#
# [*startsnmptrapper*]
#   If 1, snmp trapper process is started.
#
# [*listenip*]
#   List of comma delimited ip addresses that the trapper should listen on.
#
# [*housekeepingfrequency*]
#   How often Zabbix will perform housekeeping procedure (in hours).
#
# [*cachesize*]
#   Size of configuration cache, in bytes.
#
# [*startdbsyncers*]
#   Number of pre-forked instances of db syncers.
#
# [*historycachesize*]
#   Size of history cache, in bytes.
#
# [*historytextcachesize*]
#   Size of text history cache, in bytes.
#
# [*timeout*]
#   Specifies how long we wait for agent, snmp device or external check (in seconds).
#
# [*trappertimeout*]
#   Specifies how many seconds trapper may spend processing new data.
#
# [*unreachableperiod*]
#   After how many seconds of unreachability treat a host as unavailable.
#
# [*unavailabledelay*]
#   How often host is checked for availability during the unavailability period, in seconds.
#
# [*unreachabledelay*]
#   How often host is checked for availability during the unreachability period, in seconds.
#
# [*externalscripts*]
#   Full path to location of external scripts.
#
# [*fpinglocation*]
#   Location of fping.
#
# [*fping6location*]
#   Location of fping6.
#
# [*sshkeylocation*]
#   Location of public and private keys for ssh checks and actions.
#
# [*logslowqueries*]
#   How long a database query may take before being logged (in milliseconds).
#
# [*tmpdir*]
#   Temporary directory.
#
# [*allowroot*]
#   Allow the server to run as 'root'.
#
# [*include_dir*]
#   You may include individual files or all files in a directory in the configuration file.
#
# [*loadmodulepath*]
#   Full path to location of server modules.
#
# [*loadmodule*]
#   Module to load at server startup.
#
# === Example
#
#  class { 'zabbix::proxy':
#    zabbix_server_host => '192.168.1.1',
#    zabbix_server_port => '10051',
#  }
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::proxy (
  $dbtype                  = $zabbix::params::dbtype,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $manage_database         = $zabbix::params::manage_database,
  $manage_firewall         = $zabbix::params::manage_firewall,
  $manage_repo             = $zabbix::params::manage_repo,
  $manage_resources        = $zabbix::params::manage_resources,
  $use_ip                  = $zabbix::params::proxy_use_ip,
  $zbx_templates           = $zabbix::params::proxy_zbx_templates,
  $mode                    = $zabbix::params::proxy_mode,
  $zabbix_server_host      = $zabbix::params::proxy_zabbix_server_host,
  $zabbix_server_port      = $zabbix::params::proxy_zabbix_server_port,
  $listenport              = $zabbix::params::proxy_listenport,
  $sourceip                = $zabbix::params::proxy_sourceip,
  $logfile                 = $zabbix::params::proxy_logfile,
  $logfilesize             = $zabbix::params::proxy_logfilesize,
  $debuglevel              = $zabbix::params::proxy_debuglevel,
  $pidfile                 = $zabbix::params::proxy_pidfile,
  $dbhost                  = $zabbix::params::proxy_dbhost,
  $dbname                  = $zabbix::params::proxy_dbname,
  $dbschema                = $zabbix::params::proxy_dbschema,
  $dbuser                  = $zabbix::params::proxy_dbuser,
  $dbpassword              = $zabbix::params::proxy_dbpassword,
  $dbsocket                = $zabbix::params::proxy_dbsocket,
  $dbport                  = $zabbix::params::proxy_dbport,
  $localbuffer             = $zabbix::params::proxy_localbuffer,
  $offlinebuffer           = $zabbix::params::proxy_offlinebuffer,
  $heartbeatfrequency      = $zabbix::params::proxy_heartbeatfrequency,
  $configfrequency         = $zabbix::params::proxy_configfrequency,
  $datasenderfrequency     = $zabbix::params::proxy_datasenderfrequency,
  $startpollers            = $zabbix::params::proxy_startpollers,
  $startipmipollers        = $zabbix::params::proxy_startipmipollers,
  $startpollersunreachable = $zabbix::params::proxy_startpollersunreachable,
  $starttrappers           = $zabbix::params::proxy_starttrappers,
  $startpingers            = $zabbix::params::proxy_startpingers,
  $startdiscoverers        = $zabbix::params::proxy_startdiscoverers,
  $starthttppollers        = $zabbix::params::proxy_starthttppollers,
  $javagateway             = $zabbix::params::proxy_javagateway,
  $javagatewayport         = $zabbix::params::proxy_javagatewayport,
  $startjavapollers        = $zabbix::params::proxy_startjavapollers,
  $startvmwarecollector    = $zabbix::params::proxy_startvmwarecollector,
  $vmwarefrequency         = $zabbix::params::proxy_vmwarefrequency,
  $vmwarecachesize         = $zabbix::params::proxy_vmwarecachesize,
  $snmptrapperfile         = $zabbix::params::proxy_snmptrapperfile,
  $snmptrapper             = $zabbix::params::proxy_snmptrapper,
  $listenip                = $zabbix::params::proxy_listenip,
  $housekeepingfrequency   = $zabbix::params::proxy_housekeepingfrequency,
  $casesize                = $zabbix::params::proxy_casesize,
  $startdbsyncers          = $zabbix::params::proxy_startdbsyncers,
  $historycachesize        = $zabbix::params::proxy_historycachesize,
  $historytextcachesize    = $zabbix::params::proxy_historytextcachesize,
  $timeout                 = $zabbix::params::proxy_timeout,
  $trappertimeout          = $zabbix::params::proxy_trappertimeout,
  $unreachableperiod       = $zabbix::params::proxy_unreachableperiod,
  $unavaliabledelay        = $zabbix::params::proxy_unavaliabledelay,
  $unreachabedelay         = $zabbix::params::proxy_unreachabedelay,
  $externalscripts         = $zabbix::params::proxy_externalscripts,
  $fpinglocation           = $zabbix::params::proxy_fpinglocation,
  $fping6location          = $zabbix::params::proxy_fping6location,
  $sshkeylocation          = $zabbix::params::proxy_sshkeylocationundef,
  $loglowqueries           = $zabbix::params::proxy_loglowqueries,
  $tmpdir                  = $zabbix::params::proxy_tmpdir,
  $allowroot               = $zabbix::params::proxy_allowroot,
  $include_dir             = $zabbix::params::proxy_include,
  $loadmodulepath          = $zabbix::params::proxy_loadmodulepath,
  $loadmodule              = $zabbix::params::proxy_loadmodule,
) inherits zabbix::params {

  # Check some if they are boolean
  validate_bool($manage_database)
  validate_bool($manage_firewall)
  validate_bool($manage_repo)
  validate_bool($manage_resources)

  # Find if listenip is set. If not, we can set to specific ip or
  # to network name. If more than 1 interfaces are available, we
  # can find the ipaddress of this specific interface if listenip
  # is set to for example "eth1" or "bond0.73".
  if ($listenip =~ /^(eth|bond).*/) {
    $int_name = "ipaddress_${listenip}"
    $listen_ip = inline_template('<%= scope.lookupvar(int_name) %>')
  } elsif is_ip_address($listenip) {
    $listen_ip = $listenip
  } else {
    $listen_ip = undef
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    class { 'zabbix::resources::proxy':
      hostname  => $::fqdn,
      ipaddress => $listen_ip,
      use_ip    => $use_ip,
      mode      => $mode,
      port      => $listenport,
      templates => $zbx_templates,
    }
    zabbix::userparameters { 'Zabbix_Proxy':
      template => 'Template App Zabbix Proxy',
    }

  }

  # Use the correct db.
  case $dbtype {
    'postgresql': {
      $db = 'pgsql'
    }
    'mysql': {
      $db = 'mysql'
    }
    default: {
      fail("Unrecognized database type for proxy: ${dbtype}")
    }
  }

  # Check if manage_repo is true.
  if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package["zabbix-proxy-${db}"] {require => Class['zabbix::repo']}
  }

  case $::operatingsystem {
    'redhat','centos','oraclelinux' : {
      package { 'zabbix-proxy':
        ensure  => present,
        require => Package["zabbix-proxy-${db}"]
      }
      # Installing the packages
      package { "zabbix-proxy-${db}":
        ensure  => present,
      }
    } # END 'redhat','centos','oraclelinux'
    default : {
      # Installing the packages
      package { "zabbix-proxy-${db}":
        ensure  => present,
      }
    } # END default
  } # END case $::operatingsystem

  # Workaround for: The redhat provider can not handle attribute enable
  # This is only happening when using an redhat family version 5.x.
  if $::osfamily == 'redhat' and $::operatingsystemrelease !~ /^5.*/ {
    Service['zabbix-proxy'] { enable     => true }
  }

  # Controlling the 'zabbix-proxy' service
  service { 'zabbix-proxy':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package["zabbix-proxy-${db}"],
      File[$include_dir],
      File['/etc/zabbix/zabbix_proxy.conf']
    ],
  }

  # if we want to manage the databases, we do
  # some stuff. (for maintaining database only.)
  class { 'zabbix::database':
    manage_database => $manage_database,
    dbtype          => $dbtype,
    zabbix_type     => 'proxy',
    zabbix_version  => $zabbix_version,
    db_name         => $dbname,
    db_user         => $dbuser,
    db_pass         => $dbpassword,
    db_host         => $dbhost,
    before          => Service['zabbix-proxy'],
  }

  # Configuring the zabbix-proxy configuration file
  file { '/etc/zabbix/zabbix_proxy.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-proxy'],
    require => Package["zabbix-proxy-${db}"],
    replace => true,
    content => template('zabbix/zabbix_proxy.conf.erb'),
  }

  # Include dir for specific zabbix-proxy checks.
  file { $include_dir:
    ensure  => directory,
    require => File['/etc/zabbix/zabbix_proxy.conf'],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '151 zabbix-proxy':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }
}
