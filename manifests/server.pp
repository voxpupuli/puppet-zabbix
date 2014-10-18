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
# [*zabbix_url*]
#   Url on which zabbix needs to be available. Will create an vhost in
#   apache. Only needed when manage_vhost is set to true.
#   Example: zabbix.example.com
#
# [*dbtype*]
#   Type of database. Can use the following 3 databases:
#   - postgresql
#   - mysql
#
# [*zabbix_version*]
#   This is the zabbix version.
#   Example: 2.2
#
# [*zabbix_timezone*]
#   The current timezone for vhost configuration needed for the php timezone.
#   Example: Europe/Amsterdam
#
# [*manage_database*]
#   When true, it will configure the database and execute the sql scripts.
#
# [*manage_vhost*]
#   When true, it will create an vhost for apache. The parameter zabbix_url
#   has to be set.
#
# [*manage_firewall*]
#   When true, it will create iptables rules.
#
# [*manage_repo*]
#   When true, it will create repository for installing the server.
#
# [*manage_resouces*]
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
#
# [*apache_use_ssl*]
#   Will create an ssl vhost. Also nonssl vhost will be created for redirect 
#   nonssl to ssl vhost.
#
# [*apache_ssl_cert*]
#   The location of the ssl certificate file. You'll need to make sure this 
#   file is present on the system, this module will not install this file.
#
# [*apache_ssl_key*]
#   The location of the ssl key file. You'll need to make sure this file is 
#   present on the system, this module will not install this file.
#
# [*apache_ssl_cipher*]
#   The ssl cipher used. Cipher is used from this website:
#   https://wiki.mozilla.org/Security/Server_Side_TLS
#
# [*apache_ssl_chain*}
#   The ssl chain file.
#
# [*zabbix_api_user*]
#   Name of the user which the api should connect to. Default: Admin
#
# [*zabbix_api_pass*]
#   Password of the user which connects to the api. Default: zabbix
#
# [*nodeid*]
#   Unique nodeid in distributed setup.
#   (Deprecated since 2.4)
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
#   (Deprecated since 2.4)
#
# [*nodenohistory*]
#   If set to '1' local history won't be sent to master node.
#   (Deprecated since 2.4)
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
  $zabbix_url              = '',
  $dbtype                  = $zabbix::params::dbtype,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $zabbix_timezone         = $zabbix::params::zabbix_timezone,
  $manage_database         = $zabbix::params::manage_database,
  $manage_vhost            = $zabbix::params::manage_vhost,
  $manage_firewall         = $zabbix::params::manage_firewall,
  $manage_repo             = $zabbix::params::manage_repo,
  $manage_resources        = $zabbix::params::manage_resources,
  $apache_use_ssl          = $zabbix::params::apache_use_ssl,
  $apache_ssl_cert         = $zabbix::params::apache_ssl_cert,
  $apache_ssl_key          = $zabbix::params::apache_ssl_key,
  $apache_ssl_cipher       = $zabbix::params::apache_ssl_cipher,
  $apache_ssl_chain        = $zabbix::params::apache_ssl_chain,
  $zabbix_api_user         = $zabbix::params::server_api_user,
  $zabbix_api_pass         = $zabbix::params::server_api_pass,
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

  # Check some if they are boolean
  validate_bool($manage_database)
  validate_bool($manage_vhost)
  validate_bool($manage_firewall)
  validate_bool($manage_resources)
  validate_bool($apache_use_ssl)

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    if $::osfamily == 'redhat' {
      # With RedHat family members, the ruby-devel needs to be installed
      # when using an "gem" provider. If this package is not defined
      # we install it via this class.
      if ! defined(Package['ruby-devel']) {
        package { 'ruby-devel':
          ensure => installed,
        }
      }
      Package['zabbixapi'] { require => Package['ruby-devel']}
    }

    # Installing the zabbixapi gem package. We need this gem for
    # communicating with the zabbix-api. This is way better then
    # doing it ourself.
    package { 'zabbixapi':
      ensure   => "${zabbix_version}.0",
      provider => 'gem',
    } ->
    class { 'zabbix::resources::server':
      zabbix_url     => $zabbix_url,
      zabbix_user    => $zabbix_api_user,
      zabbix_pass    => $zabbix_api_pass,
      apache_use_ssl => $apache_use_ssl,
    }
  }

  # use the correct db.
  case $dbtype {
    'postgresql': {
      $db = 'pgsql'
    }
    'mysql': {
      $db = 'mysql'
    }
    default: {
      fail('unrecognized database type for server.')
    }
  }

  # Check if manage_repo is true.
  if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package["zabbix-server-${db}"] {require => Class['zabbix::repo']}
  }

  # Installing the packages
  package { "zabbix-server-${db}":
    ensure  => present,
  }

  case $::operatingsystem {
    'ubuntu', 'debian' : {
      package { "php5-${db}":
        ensure => present,
      } ->
      package { 'zabbix-frontend-php':
        ensure  => present,
        require => Package["zabbix-server-${db}"],
        before  => File['/etc/zabbix/web/zabbix.conf.php'],
      }
    }
    default : {
      package { "zabbix-web-${db}":
        ensure  => present,
        require => Package["zabbix-server-${db}"],
        before  => [
          File['/etc/zabbix/web/zabbix.conf.php'],
          Package['zabbix-web']
        ],
      }
      package { 'zabbix-web':
        ensure => present,
      }
    }
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
    db_host         => $dbhost,
    before          => Service['zabbix-server'],
  }

  # Workaround for: The redhat provider can not handle attribute enable
  # This is only happening when using an redhat family version 5.x.
  if $::osfamily == 'redhat' and $::operatingsystemrelease !~ /^5.*/ {
    Service['zabbix-server'] { enable     => true }
  }

  # Controlling the 'zabbix-server' service
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

  # Configuring the zabbix-server configuration file
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

  # Webinterface config file
  file { '/etc/zabbix/web/zabbix.conf.php':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-server'],
    replace => true,
    content => template('zabbix/web/zabbix.conf.php.erb'),
  }

  # Include dir for specific zabbix-server checks.
  file { $include_dir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => File['/etc/zabbix/zabbix_server.conf'],
  }

  # Is set to true, it will create the apache vhost.
  if $manage_vhost {
    include apache
    # Check if we use ssl. If so, we also create an non ssl
    # vhost for redirect traffic from non ssl to ssl site.
    if $apache_use_ssl {
      # Listen port
      $apache_listen_port = '443'
 
      # We create nonssl vhost for redirecting non ssl
      # traffic to https.
      apache::vhost { "${zabbix_url}_nonssl":
        docroot        => '/usr/share/zabbix',
        manage_docroot => false,
        port           => '80',
        servername     => $zabbix_url,
        ssl            => false,
        rewrites       => [
          {
            comment      => 'redirect all to https',
            rewrite_cond => ['%{SERVER_PORT} !^443$'],
            rewrite_rule => ["^/(.+)$ https://${zabbix_url}/\$1 [L,R]"],
          }
        ],
      }
    } else {
      # So no ssl, so default port 80
      $apache_listen_port = '80'
    }

    apache::vhost { $zabbix_url:
      docroot         => '/usr/share/zabbix',
      port            => $apache_listen_port,
      directories     => [
        { path     => '/usr/share/zabbix',
          provider => 'directory',
          allow    => 'from all',
          order    => 'Allow,Deny',
        },
        { path     => '/usr/share/zabbix/conf',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/api',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/include',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/include/classes',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
      ],
      custom_fragment => "  php_value max_execution_time 300
    php_value memory_limit 128M
    php_value post_max_size 16M
    php_value upload_max_filesize 2M
    php_value max_input_time 300
    # Set correct timezone.
    php_value date.timezone ${zabbix_timezone}",
      rewrites   => [ { rewrite_rule    => ['^$ /index.php [L]'] } ],
      ssl        => $apache_use_ssl,
      ssl_cert   => $apache_ssl_cert,
      ssl_key    => $apache_ssl_key,
      ssl_cipher => $apache_ssl_cipher,
      ssl_chain  => $apache_ssl_chain,
    }
  } # END if $manage_vhost

  # Manage firewall
  if $manage_firewall {
    firewall { '151 zabbix-server':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }

}
