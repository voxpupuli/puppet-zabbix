# @summary This will install and configure the zabbix-server deamon
# @param database_type
#   Type of database. Can use the following 2 databases:
#   - postgresql
#   - mysql
# @param database_path
#   When database binaries are not found on the default path:
#   /bin:/usr/bin:/usr/local/sbin:/usr/local/bin
#   you can use this parameter to add the database_path to the above mentioned
#   path.
# @param zabbix_version This is the zabbix version. Example: 5.0
# @param manage_repo When true (default) this module will manage the Zabbix repository.
# @param manage_database When true, it will configure the database and execute the sql scripts.
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param manage_firewall When true, it will create iptables rules.
# @param manage_service
#   When true, it will ensure service running and enabled.
#   When false, it does not care about service
# @param server_configfile_path Server config file path defaults to /etc/zabbix/zabbix_server.conf
# @param server_config_owner The owner of Zabbix's server config file.
# @param server_config_group The group of Zabbix's server config file.
# @param server_service_name The service name of Zabbix server.
# @param pacemaker Whether to control zabbix server through Pacemaker.
# @param pacemaker_resource Zabbix server pacemaker resource.
# @param listenport Listen port for the zabbix-server. Default: 10051
# @param sourceip Source ip address for outgoing connections.
# @param logfile Name of log file.
# @param logfilesize Maximum size of log file in MB.
# @param logtype Specifies where log messages are written to. (options: console, file, system)
# @param debuglevel Specifies debug level.
# @param pidfile Name of pid file.
# @param database_schema_path The path to the directory containing the .sql schema files
# @param database_host Database host name.
# @param database_name Database name.
# @param database_schema Schema name. used for ibm db2.
# @param database_user Database user. ignored for sqlite.
# @param database_password Database password. ignored for sqlite.
# @param database_socket Path to mysql socket.
# @param database_port Database port when not using local socket. Ignored for sqlite.
# @param database_tlsconnect
#   Available options:
#   * required - connect using TLS
#   * verify_ca - connect using TLS and verify certificate
#   * verify_full - connect using TLS, verify certificate and verify that database identity specified by DBHost matches its certificate
# @param database_tlscafile Full pathname of a file containing the top-level CA(s) certificates for database certificate verification.
# @param database_tlscertfile Full pathname of file containing Zabbix server certificate for authenticating to database.
# @param database_tlskeyfile Full pathname of file containing the private key for authenticating to database.
# @param database_tlscipher The list of encryption ciphers that Zabbix server permits for TLS protocols up through TLSv1.2.
# @param database_tlscipher13 The list of encryption ciphersuites that Zabbix server permits for TLSv1.3 protocol.
# @param startpollers Number of pre-forked instances of pollers.
# @param startpreprocessors Number of pre-forked instances of preprocessing workers
# @param startipmipollers Number of pre-forked instances of ipmi pollers.
# @param startodbcpollers Number of pre-forked instances of ODBC pollers.
# @param startpollersunreachable Number of pre-forked instances of pollers for unreachable hosts (including ipmi).
# @param starttrappers Number of pre-forked instances of trappers.
# @param startpingers Number of pre-forked instances of icmp pingers.
# @param startalerters Number of pre-forked instances of alerters.
# @param startdiscoverers Number of pre-forked instances of discoverers.
# @param startescalators Number of pre-forked instances of escalators.
# @param starthistorypollers Number of pre-forked instances of history pollers.
# @param starthttppollers Number of pre-forked instances of http pollers.
# @param starttimers Number of pre-forked instances of timers.
# @param javagateway IP address (or hostname) of zabbix java gateway.
# @param javagatewayport Port that zabbix java gateway listens on.
# @param startjavapollers Number of pre-forked instances of java pollers.
# @param startlldprocessors Number of pre-forked instances of low-level discovery (LLD) workers.
# @param startvmwarecollectors Number of pre-forked vmware collector instances.
# @param startreportwriters Number of pre-forked report writer instances.
# @param webserviceurl URL to Zabbix web service, used to perform web related tasks.
# @param vmwarefrequency How often zabbix will connect to vmware service to obtain a new datan.
# @param vaultdbpath Vault path from where credentials for database will be retrieved by keys 'password' and 'username'.
# @param vaulttoken
#   Vault authentication token that should have been generated exclusively for Zabbix proxy with read-only
#   permission to the path specified in the optional VaultDBPath configuration parameter.
# @param vaulturl Vault server HTTP[S] URL. System-wide CA certificates directory will be used if SSLCALocation is not specified.
# @param vmwarecachesize Size of vmware cache, in bytes.
# @param vmwaretimeout The maximum number of seconds vmware collector will wait for a response from VMware service.
# @param snmptrapperfile Temporary file used for passing data from snmp trap daemon to the server.
# @param startsnmptrapper If 1, snmp trapper process is started.
# @param listenip List of comma delimited ip addresses that the zabbix-server should listen on.
# @param housekeepingfrequency How often zabbix will perform housekeeping procedure (in hours).
# @param maxhousekeeperdelete
#   the table "housekeeper" contains "tasks" for housekeeping procedure in the format:
#   [housekeeperid], [tablename], [field], [value].
#   no more than 'maxhousekeeperdelete' rows (corresponding to [tablename], [field], [value])
#   will be deleted per one task in one housekeeping cycle.
#   sqlite3 does not use this parameter, deletes all corresponding rows without a limit.
#   if set to 0 then no limit is used at all. in this case you must know what you are doing!
# @param cachesize Size of configuration cache, in bytes.
# @param cacheupdatefrequency How often zabbix will perform update of configuration cache, in seconds.
# @param smsdevices What devices to use for texting
# @param startdbsyncers Number of pre-forked instances of db syncers.
# @param historycachesize Size of history cache, in bytes.
# @param historyindexcachesize Size of history index cache, in bytes.
# @param trendcachesize Size of trend cache, in bytes.
# @param trendfunctioncachesize Size of trend function cache, in bytes.
# @param valuecachesize Size of history value cache, in bytes.
# @param timeout Specifies how long we wait for agent, snmp device or external check (in seconds).
# @param tlscafile Full pathname of a file containing the top-level CA(s) certificates for peer certificate verification.
# @param tlscertfile Full pathname of a file containing the server certificate or certificate chain.
# @param tlscrlfile Full pathname of a file containing revoked certificates.
# @param tlskeyfile Full pathname of a file containing the server private key.
# @param tlscipherall
#   GnuTLS priority string or OpenSSL (TLS 1.2) cipher string. Override the default ciphersuite selection criteria
#   for certificate- and PSK-based encryption.
# @param tlscipherall13
#   Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3. Override the default ciphersuite selection criteria
#   for certificate- and PSK-based encryption.
# @param tlsciphercert
#   GnuTLS priority string or OpenSSL (TLS 1.2) cipher string. Override the default ciphersuite selection criteria
#   for certificate-based encryption.
# @param tlsciphercert13
#   Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3. Override the default ciphersuite selection criteria
#   for certificate-based encryption.
# @param tlscipherpsk
#  GnuTLS priority string or OpenSSL (TLS 1.2) cipher string. Override the default ciphersuite selection criteria
#  for PSK-based encryption.
# @param tlscipherpsk13
#  Cipher string for OpenSSL 1.1.1 or newer in TLS 1.3. Override the default ciphersuite selection criteria
#  for PSK-based encryption.
# @param trappertimeout Specifies how many seconds trapper may spend processing new data.
# @param unreachableperiod After how many seconds of unreachability treat a host as unavailable.
# @param unavailabledelay How often host is checked for availability during the unavailability period, in seconds.
# @param unreachabledelay How often host is checked for availability during the unreachability period, in seconds.
# @param alertscriptspath Full path to location of custom alert scripts.
# @param externalscripts Full path to location of external scripts.
# @param fpinglocation Location of fping.
# @param fping6location Location of fping6.
# @param sshkeylocation Location of public and private keys for ssh checks and actions.
# @param logslowqueries How long a database query may take before being logged (in milliseconds).
# @param tmpdir Temporary directory.
# @param startproxypollers Number of pre-forked instances of pollers for passive proxies.
# @param proxyconfigfrequency How often zabbix server sends configuration data to a zabbix proxy in seconds.
# @param proxydatafrequency How often zabbix server requests history data from a zabbix proxy in seconds.
# @param allowroot Allow the server to run as 'root'.
# @param include_dir You may include individual files or all files in a directory in the configuration file.
# @param statsallowedip list of allowed ipadresses that can access the internal stats of zabbix server over network
# @param loadmodulepath Full path to location of server modules.
# @param loadmodule Module to load at server startup.
# @param sslcertlocation_dir Location of SSL client certificate files for client authentication.
# @param sslkeylocation_dir Location of SSL private key files for client authentication.
# @param manage_selinux Whether we should manage SELinux rules.
# @param additional_service_params Additional parameters to pass to the service.
# @param zabbix_user User the zabbix service will run as.
# @param manage_startup_script If the init script should be managed by this module. Attention: This might cause problems with some config options of this module (e.g server_configfile_path)
# @param socketdir
# @param hanodename Node name identifier in HA setup
# @param nodeaddress Connection details to the HA node, used to check if zabbix-web can talk to zabbix server
#   IPC socket directory.
#   Directory to store IPC sockets used by internal Zabbix services.
# @example
#   When running everything on a single node, please check
#   documentation in init.pp
#   The following is an example of an multiple host setup:
#
#   node 'wdpuppet03.dj-wasabi.local' {
#     #class { 'postgresql::client': }
#     class { 'mysql::client': }
#     class { 'zabbix::server':
#       zabbix_version => '2.4',
#       database_host  => 'wdpuppet04.dj-wasabi.local',
#       database_type  => 'mysql',
#     }
#   }
#
#   The setup of above shows an configuration which used mysql as database.
#   It will require the database "client" classes, this is needed for executing
#   the installation files.
#
#   When database_type = postgres, uncomment the postgresql::client class and change or
#   remove the database_type parameter and comment the mysql::client class.
#
# @author Werner Dijkerman ikben@werner-dijkerman.nl#
class zabbix::server (
  Zabbix::Databases $database_type                                            = $zabbix::params::database_type,
  $database_path                                                              = $zabbix::params::database_path,
  $zabbix_version                                                             = $zabbix::params::zabbix_version,
  $zabbix_package_state                                                       = $zabbix::params::zabbix_package_state,
  Boolean $manage_firewall                                                    = $zabbix::params::manage_firewall,
  Boolean $manage_repo                                                        = $zabbix::params::manage_repo,
  Boolean $manage_database                                                    = $zabbix::params::manage_database,
  Boolean $manage_service                                                     = $zabbix::params::manage_service,
  $server_configfile_path                                                     = $zabbix::params::server_configfile_path,
  $server_config_owner                                                        = $zabbix::params::server_config_owner,
  $server_config_group                                                        = $zabbix::params::server_config_group,
  $server_service_name                                                        = $zabbix::params::server_service_name,
  $pacemaker                                                                  = $zabbix::params::server_pacemaker,
  $pacemaker_resource                                                         = $zabbix::params::server_pacemaker_resource,
  $listenport                                                                 = $zabbix::params::server_listenport,
  $sourceip                                                                   = $zabbix::params::server_sourceip,
  Enum['console', 'file', 'system'] $logtype                                  = $zabbix::params::server_logtype,
  Optional[Stdlib::Absolutepath] $logfile                                     = $zabbix::params::server_logfile,
  $logfilesize                                                                = $zabbix::params::server_logfilesize,
  $debuglevel                                                                 = $zabbix::params::server_debuglevel,
  $pidfile                                                                    = $zabbix::params::server_pidfile,
  $database_schema_path                                                       = $zabbix::params::database_schema_path,
  $database_host                                                              = $zabbix::params::server_database_host,
  $database_name                                                              = $zabbix::params::server_database_name,
  $database_schema                                                            = $zabbix::params::server_database_schema,
  $database_user                                                              = $zabbix::params::server_database_user,
  $database_password                                                          = $zabbix::params::server_database_password,
  $database_socket                                                            = $zabbix::params::server_database_socket,
  Optional[Stdlib::Port::Unprivileged] $database_port                         = $zabbix::params::server_database_port,
  Optional[Enum['required', 'verify_ca', 'verify_full']] $database_tlsconnect = $zabbix::params::server_database_tlsconnect,
  Optional[Stdlib::Absolutepath] $database_tlscafile                          = $zabbix::params::server_database_tlscafile,
  Optional[Stdlib::Absolutepath] $database_tlscertfile                        = $zabbix::params::server_database_tlscertfile,
  Optional[Stdlib::Absolutepath] $database_tlskeyfile                         = $zabbix::params::server_database_tlskeyfile,
  Optional[String[1]] $database_tlscipher                                     = $zabbix::params::server_database_tlscipher,
  Optional[String[1]] $database_tlscipher13                                   = $zabbix::params::server_database_tlscipher13,
  Array[String[1]] $smsdevices                                                = $zabbix::params::server_smsdevices,
  $startpollers                                                               = $zabbix::params::server_startpollers,
  $startipmipollers                                                           = $zabbix::params::server_startipmipollers,
  Integer[0, 1000] $startodbcpollers                                          = $zabbix::params::server_startodbcpollers,
  $startpollersunreachable                                                    = $zabbix::params::server_startpollersunreachable,
  Integer[1, 1000] $startpreprocessors                                        = $zabbix::params::server_startpreprocessors,
  $starttrappers                                                              = $zabbix::params::server_starttrappers,
  $startpingers                                                               = $zabbix::params::server_startpingers,
  Integer[1, 100] $startalerters                                              = $zabbix::params::server_startalerters,
  $startdiscoverers                                                           = $zabbix::params::server_startdiscoverers,
  Integer[1, 100] $startescalators                                            = $zabbix::params::server_startescalators,
  Optional[Integer[0, 100]] $starthistorypollers                              = $zabbix::params::server_starthistorypollers,
  $starthttppollers                                                           = $zabbix::params::server_starthttppollers,
  $starttimers                                                                = $zabbix::params::server_starttimers,
  $javagateway                                                                = $zabbix::params::server_javagateway,
  $javagatewayport                                                            = $zabbix::params::server_javagatewayport,
  $startjavapollers                                                           = $zabbix::params::server_startjavapollers,
  Integer[1, 100] $startlldprocessors                                         = $zabbix::params::server_startlldprocessors,
  Optional[Integer[1, 100]] $startreportwriters                               = undef,
  $startvmwarecollectors                                                      = $zabbix::params::server_startvmwarecollectors,
  Optional[String[1]] $vaultdbpath                                            = $zabbix::params::server_vaultdbpath,
  Optional[String[1]] $vaulttoken                                             = $zabbix::params::server_vaulttoken,
  Stdlib::HTTPSUrl $vaulturl                                                  = $zabbix::params::server_vaulturl,
  $vmwarefrequency                                                            = $zabbix::params::server_vmwarefrequency,
  $vmwarecachesize                                                            = $zabbix::params::server_vmwarecachesize,
  $vmwaretimeout                                                              = $zabbix::params::server_vmwaretimeout,
  $snmptrapperfile                                                            = $zabbix::params::server_snmptrapperfile,
  $startsnmptrapper                                                           = $zabbix::params::server_startsnmptrapper,
  $listenip                                                                   = $zabbix::params::server_listenip,
  $housekeepingfrequency                                                      = $zabbix::params::server_housekeepingfrequency,
  $maxhousekeeperdelete                                                       = $zabbix::params::server_maxhousekeeperdelete,
  $cachesize                                                                  = $zabbix::params::server_cachesize,
  $cacheupdatefrequency                                                       = $zabbix::params::server_cacheupdatefrequency,
  $startdbsyncers                                                             = $zabbix::params::server_startdbsyncers,
  $historycachesize                                                           = $zabbix::params::server_historycachesize,
  $historyindexcachesize                                                      = $zabbix::params::server_historyindexcachesize,
  $trendcachesize                                                             = $zabbix::params::server_trendcachesize,
  Optional[String[1]] $trendfunctioncachesize                                 = $zabbix::params::server_trendfunctioncachesize,
  $valuecachesize                                                             = $zabbix::params::server_valuecachesize,
  $timeout                                                                    = $zabbix::params::server_timeout,
  $tlscafile                                                                  = $zabbix::params::server_tlscafile,
  $tlscertfile                                                                = $zabbix::params::server_tlscertfile,
  $tlscrlfile                                                                 = $zabbix::params::server_tlscrlfile,
  $tlskeyfile                                                                 = $zabbix::params::server_tlskeyfile,
  Optional[String[1]] $tlscipherall                                           = $zabbix::params::server_tlscipherall,
  Optional[String[1]] $tlscipherall13                                         = $zabbix::params::server_tlscipherall13,
  Optional[String[1]] $tlsciphercert                                          = $zabbix::params::server_tlsciphercert,
  Optional[String[1]] $tlsciphercert13                                        = $zabbix::params::server_tlsciphercert13,
  Optional[String[1]] $tlscipherpsk                                           = $zabbix::params::server_tlscipherpsk,
  Optional[String[1]] $tlscipherpsk13                                         = $zabbix::params::server_tlscipherpsk13,
  $trappertimeout                                                             = $zabbix::params::server_trappertimeout,
  $unreachableperiod                                                          = $zabbix::params::server_unreachableperiod,
  $unavailabledelay                                                           = $zabbix::params::server_unavailabledelay,
  $unreachabledelay                                                           = $zabbix::params::server_unreachabledelay,
  $alertscriptspath                                                           = $zabbix::params::server_alertscriptspath,
  $externalscripts                                                            = $zabbix::params::server_externalscripts,
  $fpinglocation                                                              = $zabbix::params::server_fpinglocation,
  $fping6location                                                             = $zabbix::params::server_fping6location,
  $sshkeylocation                                                             = $zabbix::params::server_sshkeylocation,
  $logslowqueries                                                             = $zabbix::params::server_logslowqueries,
  $tmpdir                                                                     = $zabbix::params::server_tmpdir,
  $startproxypollers                                                          = $zabbix::params::server_startproxypollers,
  $proxyconfigfrequency                                                       = $zabbix::params::server_proxyconfigfrequency,
  $proxydatafrequency                                                         = $zabbix::params::server_proxydatafrequency,
  $allowroot                                                                  = $zabbix::params::server_allowroot,
  $include_dir                                                                = $zabbix::params::server_include,
  $loadmodulepath                                                             = $zabbix::params::server_loadmodulepath,
  $loadmodule                                                                 = $zabbix::params::server_loadmodule,
  $sslcertlocation_dir                                                        = $zabbix::params::server_sslcertlocation,
  $sslkeylocation_dir                                                         = $zabbix::params::server_sslkeylocation,
  Optional[String[1]] $statsallowedip                                         = $zabbix::params::server_statsallowedip,
  Boolean $manage_selinux                                                     = $zabbix::params::manage_selinux,
  String $additional_service_params                                           = $zabbix::params::additional_service_params,
  Optional[String[1]] $zabbix_user                                            = $zabbix::params::server_zabbix_user,
  Boolean $manage_startup_script                                              = $zabbix::params::manage_startup_script,
  Optional[Stdlib::Absolutepath] $socketdir                                   = $zabbix::params::server_socketdir,
  Optional[Stdlib::HTTPUrl] $webserviceurl                                    = undef,
  Optional[String[1]] $hanodename                                             = $zabbix::params::server_hanodename,
  Optional[String[1]] $nodeaddress                                            = $zabbix::params::server_nodeaddress,
) inherits zabbix::params {
  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
      zabbix_version => $zabbix_version,
      manage_repo    => $manage_repo,
    }
  }

  if versioncmp($zabbix_version, '5.4') >= 0 {
    package { 'zabbix-sql-scripts':
      ensure  => present,
      require => Class['zabbix::repo'],
      tag     => 'zabbix',
    }
  }

  # Get the correct database_type. We need this for installing the
  # correct package and loading the sql files.
  case $database_type {
    'postgresql' : {
      $db = 'pgsql'

      # Zabbix version >= 5.4 uses zabbix-sql-scripts for initializing the database.
      if versioncmp($zabbix_version, '5.4') >= 0 {
        $zabbix_database_require = [Package["zabbix-server-${db}"], Package['zabbix-sql-scripts']]
      } else {
        $zabbix_database_require = Package["zabbix-server-${db}"]
      }

      if $manage_database {
        # Execute the postgresql scripts
        class { 'zabbix::database::postgresql':
          zabbix_type          => 'server',
          zabbix_version       => $zabbix_version,
          database_schema_path => $database_schema_path,
          database_name        => $database_name,
          database_user        => $database_user,
          database_password    => $database_password,
          database_host        => $database_host,
          database_port        => $database_port,
          database_path        => $database_path,
          require              => $zabbix_database_require,
        }
      }
    }
    'mysql' : {
      $db = 'mysql'

      # Zabbix version >= 5.4 uses zabbix-sql-scripts for initializing the database.
      if versioncmp($zabbix_version, '5.4') >= 0 {
        $zabbix_database_require = [Package["zabbix-server-${db}"], Package['zabbix-sql-scripts']]
      } else {
        $zabbix_database_require = Package["zabbix-server-${db}"]
      }

      if $manage_database {
        # Execute the mysql scripts
        class { 'zabbix::database::mysql':
          zabbix_type          => 'server',
          zabbix_version       => $zabbix_version,
          database_schema_path => $database_schema_path,
          database_name        => $database_name,
          database_user        => $database_user,
          database_password    => $database_password,
          database_host        => $database_host,
          database_port        => $database_port,
          database_path        => $database_path,
          require              => $zabbix_database_require,
        }
      }
    }
    default      : {
      fail('unrecognized database type for server.')
    }
  }

  # Installing the packages
  package { "zabbix-server-${db}":
    ensure  => $zabbix_package_state,
    require => Class['zabbix::repo'],
    tag     => 'zabbix',
  }

  # Ensure that the correct config file is used.
  if $manage_startup_script {
    zabbix::startup { 'zabbix-server':
      pidfile                   => $pidfile,
      database_type             => $database_type,
      server_configfile_path    => $server_configfile_path,
      zabbix_user               => $zabbix_user,
      additional_service_params => $additional_service_params,
      manage_database           => $manage_database,
      service_name              => 'zabbix-server',
      require                   => Package["zabbix-server-${db}"],
    }

    $require_for_service = [Package["zabbix-server-${db}"], File[$include_dir], File[$server_configfile_path], Zabbix::Startup['zabbix-server']]
  } else {
    $require_for_service = [Package["zabbix-server-${db}"], File[$include_dir], File[$server_configfile_path]]
  }

  if $server_configfile_path != '/etc/zabbix/zabbix_server.conf' {
    file { '/etc/zabbix/zabbix_server.conf':
      ensure  => absent,
      require => Package["zabbix-server-${db}"],
    }
  }

  # Controlling the 'zabbix-server' service
  if $pacemaker {
    exec { 'prevent zabbix boot-start':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "systemctl disable ${server_service_name}",
      onlyif  => "systemctl is-enabled ${server_service_name} | grep enabled >> /dev/null",
    }

    exec { 'stop zabbix if running without pacemaker':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "systemctl stop ${server_service_name}",
      onlyif  => "systemctl status ${server_service_name} | grep running >> /dev/null",
      unless  => "systemctl status ${server_service_name} | grep pacemaker >> /dev/null",
    }

    service { $server_service_name:
      ensure     => running,
      provider   => 'base',
      hasstatus  => true,
      hasrestart => true,
      status     => "/usr/sbin/pcs status resources | grep ${pacemaker_resource} | grep Started; echo $?",
      restart    => "/usr/sbin/pcs resource restart ${pacemaker_resource}",
      start      => "/usr/sbin/pcs resource start ${pacemaker_resource}",
      stop       => "/usr/sbin/pcs resource stop ${pacemaker_resource}",
      require    => [
        Package["zabbix-server-${db}"],
        File[$include_dir],
        File[$server_configfile_path],
      ],
    }
  } else {
    if $manage_service {
      service { $server_service_name:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => $require_for_service,
        subscribe  => File[$server_configfile_path],
      }
    }
  }

  # Configuring the zabbix-server configuration file
  file { $server_configfile_path:
    ensure  => file,
    owner   => $server_config_owner,
    group   => $server_config_group,
    mode    => '0640',
    require => Package["zabbix-server-${db}"],
    replace => true,
    content => template('zabbix/zabbix_server.conf.erb'),
  }

  # Include dir for specific zabbix-server checks.
  file { $include_dir:
    ensure  => directory,
    owner   => $server_config_owner,
    group   => $server_config_group,
    require => File[$server_configfile_path],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '151 zabbix-server':
      dport => $listenport,
      proto => 'tcp',
      jump  => 'accept',
      state => [
        'NEW',
        'RELATED',
        'ESTABLISHED',
      ],
    }
  }

  $dependency = $manage_service ? {
    true  => Service[$server_service_name],
    false => undef,
  }
  # check if selinux is active and allow zabbix
  if fact('os.selinux.enabled') == true and $manage_selinux {
    ensure_resource ('selboolean',
      [
        'zabbix_can_network',
      ], {
        persistent => true,
        value      => 'on',
    })
    selinux::module { 'zabbix-server':
      ensure    => 'present',
      source_te => 'puppet:///modules/zabbix/zabbix-server.te',
      before    => $dependency,
      require   => Selboolean['zabbix_can_network'],
    }
    selinux::module { 'zabbix-server-ipc':
      ensure    => 'present',
      source_te => 'puppet:///modules/zabbix/zabbix-server-ipc.te',
      before    => $dependency,
    }
  }
}
