# == Class: zabbix::server
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
# [*nodeid*]
#   Unique nodeid in distributed setup.
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
# [*starttimers*]
#   Number of pre-forked instances of timers.
#
# [*javagateway*]
#   IP address (or hostname) of zabbix java gateway.
#
# [*javagatewayport*]
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
#   How often zabbix will perform housekeeping procedure (in hours).
#
# [*maxhousekeeperdelete*]
#   the table "housekeeper" contains "tasks" for housekeeping procedure in the format:
#   [housekeeperid], [tablename], [field], [value].
#   no more than 'maxhousekeeperdelete' rows (corresponding to [tablename], [field], [value])
#   will be deleted per one task in one housekeeping cycle.
#   sqlite3 does not use this parameter, deletes all corresponding rows without a limit.
#   if set to 0 then no limit is used at all. in this case you must know what you are doing!
#
# [*senderfrequency*]
#   How often zabbix will try to send unsent alerts (in seconds).
#
# [*cachesize*]
#   Size of configuration cache, in bytes.
#
# [*cacheupdatefrequency*]
#   How often zabbix will perform update of configuration cache, in seconds.
#
# [*startdbsyncers*]
#   Number of pre-forked instances of db syncers.
#
# [*historycachesize*]
#   Size of history cache, in bytes.
#
# [*trendcachesize*]
#   Size of trend cache, in bytes.
#
# [*historytextcachesize*]
#   Size of text history cache, in bytes.
#
# [*valuecachesize*]
#   Size of history value cache, in bytes.
#
# [*nodenoevents*]
#   If set to '1' local events won't be sent to master node.
#
# [*nodenohistory*]
#   If set to '1' local history won't be sent to master node.
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
# [*alertscriptspath*]
#   Full path to location of custom alert scripts.
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
# [*startproxypollers*]
#   Number of pre-forked instances of pollers for passive proxies.
#
# [*proxyconfigfrequency*]
#   How often zabbix server sends configuration data to a zabbix proxy in seconds.
#
# [*proxydatafrequency*]
#   How often zabbix server requests history data from a zabbix proxy in seconds.
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
#  class { 'zabbix::agent':
#    zabbix_version => '2.2',
#    server         => '192.168.1.1',
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
class zabbix::server (
  $dbtype                  = $zabbix::params::dbtype,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $manage_database         = $zabbix::params::manage_database,
  $nodeid                  = $zabbix::params::server_nodeid,
  $listenport              = $zabbix::params::server_listenport,
  $sourceip                = $zabbix::params::server_sourceip,
  $logfile                 = $zabbix::params::server_logfile,
  $logfilesize             = $zabbix::params::server_logfilesize,
  $debuglevel              = $zabbix::params::server_debuglevel,
  $pidfile                 = $zabbix::params::server_pidfile,
  $dbhost                  = $zabbix::params::server_dbhost,
  $dbname                  = $zabbix::params::server_dbname,
  $dbschema                = $zabbix::params::server_dbschema,
  $dbuser                  = $zabbix::params::server_dbuser,
  $dbpassword              = $zabbix::params::server_dbpassword,
  $dbsocket                = $zabbix::params::server_dbsocket,
  $dbport                  = $zabbix::params::server_dbport,
  $startpollers            = $zabbix::params::server_startpollers,
  $startipmipollers        = $zabbix::params::server_startipmipollers,
  $startpollersunreachable = $zabbix::params::server_startpollersunreachable,
  $starttrappers           = $zabbix::params::server_starttrappers,
  $startpingers            = $zabbix::params::server_startpingers,
  $startdiscoverers        = $zabbix::params::server_startdiscoverers,
  $starthttppollers        = $zabbix::params::server_starthttppollers,
  $starttimers             = $zabbix::params::server_starttimers,
  $javagateway             = $zabbix::params::server_javagateway,
  $javagatewayport         = $zabbix::params::server_javagatewayport,
  $startjavapollers        = $zabbix::params::server_startjavapollers,
  $startvmwarecollectors   = $zabbix::params::server_startvmwarecollectors,
  $vmwarefrequency         = $zabbix::params::server_vmwarefrequency,
  $vmwarecachesize         = $zabbix::params::server_vmwarecachesize,
  $snmptrapperfile         = $zabbix::params::server_snmptrapperfile,
  $startsnmptrapper        = $zabbix::params::server_startsnmptrapper,
  $listenip                = $zabbix::params::server_listenip,
  $housekeepingfrequency   = $zabbix::params::server_housekeepingfrequency,
  $maxhousekeeperdelete    = $zabbix::params::server_maxhousekeeperdelete,
  $senderfrequency         = $zabbix::params::server_senderfrequency,
  $cachesize               = $zabbix::params::server_cachesize,
  $cacheupdatefrequency    = $zabbix::params::server_cacheupdatefrequency,
  $startdbsyncers          = $zabbix::params::server_startdbsyncers,
  $historycachesize        = $zabbix::params::server_historycachesize,
  $trendcachesize          = $zabbix::params::server_trendcachesize,
  $historytextcachesize    = $zabbix::params::server_historytextcachesize,
  $valuecachesize          = $zabbix::params::server_valuecachesize,
  $nodenoevents            = $zabbix::params::server_nodenoevents,
  $nodenohistory           = $zabbix::params::server_nodenohistory,
  $timeout                 = $zabbix::params::server_timeout,
  $trappertimeout          = $zabbix::params::server_trappertimeout,
  $unreachableperiod       = $zabbix::params::server_unreachableperiod,
  $unavailabledelay        = $zabbix::params::server_unavailabledelay,
  $unreachabledelay        = $zabbix::params::server_unreachabledelay,
  $alertscriptspath        = $zabbix::params::server_alertscriptspath,
  $externalscripts         = $zabbix::params::server_externalscripts,
  $fpinglocation           = $zabbix::params::server_fpinglocation,
  $fping6location          = $zabbix::params::server_fping6location,
  $sshkeylocation          = $zabbix::params::server_sshkeylocation,
  $logslowqueries          = $zabbix::params::server_logslowqueries,
  $tmpdir                  = $zabbix::params::server_tmpdir,
  $startproxypollers       = $zabbix::params::server_startproxypollers,
  $proxyconfigfrequency    = $zabbix::params::server_proxyconfigfrequency,
  $proxydatafrequency      = $zabbix::params::server_proxydatafrequency,
  $allowroot               = $zabbix::params::server_allowroot,
  $include_dir             = $zabbix::params::server_include,
  $loadmodulepath          = $zabbix::params::server_loadmodulepath,
  $loadmodule              = $zabbix::params::server_loadmodule,
  ) inherits zabbix::params {

  include zabbix::repo

  # use the correct db.
  case $dbtype {
    'postgresql': {
      $db      = 'pgsql'
    }
    'mysql': {
      $db      = 'mysql'
      $service = 'mysqld'
      $class   = 'mysqld'
    }
    'sqlite','sqlite3': {
      $db = 'sqlite3'
    }
    default: {
      fail('unrecognized database type for server.')
    }
  }

  package { "zabbix-server-${db}":
    ensure  => present,
    require => Class['zabbix::repo'],
  } ->
  package { "zabbix-web-${db}":
    ensure  => present,
  } ->
  package { 'zabbix-web':
    ensure  => present,
  }

  # if we want to manage the databases, we do
  # some stuff. (for maintaining database only.)
  class { 'zabbix::database':
    manage_database => $manage_database,
    dbtype          => $dbtype,
    zabbix_type     => 'server',
    zabbix_version  => $zabbix_version,
    db_name         => $dbname,
    db_user         => $dbuser,
    db_pass         => $dbpassword,
    before          => Service['zabbix-server'],
  }

  service { 'zabbix-server':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package["zabbix-server-${db}"],
      File[$include_dir],
      File['/etc/zabbix/zabbix_server.conf']
    ],
  }

  file { '/etc/zabbix/zabbix_server.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0640',
    notify  => Service['zabbix-server'],
    require => Package["zabbix-server-${db}"],
    replace => true,
    content => template('zabbix/zabbix_server.conf.erb'),
  }

  file { $include_dir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => File['/etc/zabbix/zabbix_server.conf'],
  }
}
