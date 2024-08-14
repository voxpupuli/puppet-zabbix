# @summary This will install and configure the zabbix-proxy deamon
# @param database_type Type of database. Can use the following 3 databases: postgresql, mysql, sqlite
# @param database_path
#  When database binaries are not found on the default path:
#  /bin:/usr/bin:/usr/local/sbin:/usr/local/bin
#  you can use this parameter to add the database_path to the above mentiond
#  path.
# @param zabbix_version This is the zabbix version.
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param manage_database When true, it will configure the database and execute the sql scripts.
# @param manage_firewall When true, it will create iptables rules.
# @param manage_repo When true, it will create repository for installing the proxy.
# @param manage_resources When true, it will export resources so that the zabbix-server can create via the zabbix-api proxy.
# @param manage_service
#   When true, it will ensure service running and enabled.
#   When false, it does not care about service
# @param zabbix_proxy Hostname of zabbix proxy.
# @param zabbix_proxy_ip IP of zabbix proxy.
# @param use_ip
#   When true, when creating proxies via the zabbix-api, it will configure that
#   connection should me made via ip, not fqdn.
# @param zbx_templates Template which will be added when proxy is configured.
# @param proxy_configfile_path Proxy config file path defaults to /etc/zabbix/zabbix_proxy.conf
# @param proxy_service_name The service name of Zabbix proxy.
# @param mode Proxy operating mode.
# @param zabbix_server_host Hostname or the ipaddress of the zabbix-server.
# @param zabbix_server_port Port on which the server is listening.
# @param hostname Hostname for the proxy. Default is $::fqdn or this parameter.
# @param listenport Listen port for trapper.
# @param sourceip Source ip address for outgoing connections.
# @param enableremotecommands Whether remote commands from zabbix server are allowed.
# @param logremotecommands Enable logging of executed shell commands as warnings.
# @param logfile Name of log file.
# @param logfilesize Maximum size of log file in MB.
# @param logtype Specifies where log messages are written to. Can be one of: console, file, system
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
# @param database_charset The default charset of the database.
# @param database_collate The default collation of the database.
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
# @param localbuffer Proxy will keep data locally for N hours, even if the data have already been synced with the server
# @param offlinebuffer Proxy will keep data for N hours in case if no connectivity with Zabbix Server
# @param buffermode Specifies history, discovery and auto registration data storage mechanism: disk, memory, hybrid
# @param memorybuffersize Size of shared memory cache for collected history, discovery and auto registration data, in bytes.
# @param memorybufferage Maximum age of data in proxy memory buffer, in seconds.
# @param heartbeatfrequency Unique nodeid in distributed setup.
# @param configfrequency How often proxy retrieves configuration data from Zabbix Server in seconds.
# @param proxyconfigfrequency How often proxy retrieves configuration data from Zabbix Server in seconds (Zabbix 6.4).
# @param datasenderfrequency Proxy will send collected data to the Server every N seconds.
# @param startpollers Number of pre-forked instances of pollers.
# @param startpreprocessors Number of pre-forked instances of preprocessing workers
# @param startipmipollers Number of pre-forked instances of ipmi pollers.
# @param startodbcpollers Number of pre-forked instances of ODBC pollers.
# @param startpollersunreachable Number of pre-forked instances of pollers for unreachable hosts (including ipmi).
# @param starttrappers Number of pre-forked instances of trappers.
# @param startpingers Number of pre-forked instances of icmp pingers.
# @param startdiscoverers Number of pre-forked instances of discoverers.
# @param starthttppollers Number of pre-forked instances of http pollers.
# @param javagateway IP address (or hostname) of zabbix java gateway.
# @param javagatewayport Port that zabbix java gateway listens on.
# @param startjavapollers Number of pre-forked instances of java pollers.
# @param startvmwarecollectors Number of pre-forked vmware collector instances.
# @param vmwarefrequency How often zabbix will connect to vmware service to obtain a new datan.
# @param vmwareperffrequency
#   Delay in seconds between performance counter statistics retrieval from a single VMware service.
#   This delay should be set to the least update interval of any VMware monitoring item that uses VMware performance counters.
# @param vmwaretimeout The maximum number of seconds vmware collector will wait for a response from VMware service (vCenter or ESX hypervisor).
# @param vmwarecachesize Size of vmware cache, in bytes.
# @param vaultdbpath Vault path from where credentials for database will be retrieved by keys 'password' and 'username'.
# @param vaulttoken
#   Vault authentication token that should have been generated exclusively for Zabbix proxy with read-only
#   permission to the path specified in the optional VaultDBPath configuration parameter.
# @param vaulturl Vault server HTTP[S] URL. System-wide CA certificates directory will be used if SSLCALocation is not specified.
# @param snmptrapperfile Temporary file used for passing data from snmp trap daemon to the server.
# @param snmptrapper If 1, snmp trapper process is started.
# @param listenip List of comma delimited ip addresses that the trapper should listen on.
# @param housekeepingfrequency How often Zabbix will perform housekeeping procedure (in hours).
# @param cachesize Size of configuration cache, in MB.
# @param startdbsyncers Number of pre-forked instances of db syncers.
# @param historycachesize Size of history cache, in bytes.
# @param historyindexcachesize Size of history index cache, in bytes.
# @param historytextcachesize Size of text history cache, in bytes.
# @param timeout Specifies how long we wait for agent, snmp device or external check (in seconds).
# @param tlsaccept What incoming connections to accept from Zabbix server. Used for a passive proxy, ignored on an active proxy.
# @param tlscafile Full pathname of a file containing the top-level CA(s) certificates for peer certificate verification.
# @param tlscertfile Full pathname of a file containing the proxy certificate or certificate chain.
# @param tlsconnect How the proxy should connect to Zabbix server. Used for an active proxy, ignored on a passive proxy.
# @param tlscrlfile Full pathname of a file containing revoked certificates.
# @param tlskeyfile Full pathname of a file containing the proxy private key.
# @param tlspskfile Full pathname of a file containing the pre-shared key.
# @param tlspskidentity Unique, case sensitive string used to identify the pre-shared key.
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
# @param tlsservercertissuer Allowed server certificate issuer.
# @param tlsservercertsubject Allowed server certificate subject.
# @param trappertimeout Specifies how many seconds trapper may spend processing new data.
# @param unreachableperiod After how many seconds of unreachability treat a host as unavailable.
# @param unavaliabledelay How often host is checked for availability during the unavailability period, in seconds.
# @param unreachabedelay How often host is checked for availability during the unreachability period, in seconds.
# @param externalscripts Full path to location of external scripts.
# @param fpinglocation Location of fping.
# @param fping6location Location of fping6.
# @param sshkeylocation Location of public and private keys for ssh checks and actions.
# @param statsallowedip list of allowed ipadresses that can access the internal stats of zabbix proxy over network
# @param sslcalocation_dir Location of certificate authority (CA) files for SSL server certificate verification.
# @param sslcertlocation_dir Location of SSL client certificate files for client authentication.
# @param sslkeylocation_dir Location of SSL private key files for client authentication.
# @param logslowqueries How long a database query may take before being logged (in milliseconds).
# @param tmpdir Temporary directory.
# @param allowroot Allow the server to run as 'root'.
# @param include_dir You may include individual files or all files in a directory in the configuration file.
# @param loadmodulepath Full path to location of server modules.
# @param loadmodule Module to load at server startup.
# @param manage_selinux Whether we should manage SELinux rules.
# @param socketdir IPC socket directory. Directory to store IPC sockets used by internal Zabbix services.
# @example When you want to run everything on one machine, you can use the following:
#  class { 'zabbix::proxy':
#    zabbix_server_host => '192.168.1.1',
#    zabbix_server_port => '10051',
#  }
# @example When you want to use mysql:
#  class { 'zabbix::proxy':
#    zabbix_server_host => '192.168.1.1',
#    zabbix_server_port => '10051',
#    database_type      => 'mysql',
#  }
# @example The following is an example of running the proxy on 2 servers:
#  node 'wdpuppet03.dj-wasabi.local' {
#    #class { 'postgresql::client': }
#    class { 'mysql::client': }
#    class { 'zabbix::proxy':
#      zabbix_server_host => '192.168.1.1',
#      manage_database    => false,
#      database_host      => 'wdpuppet04.dj-wasabi.local',
#      database_type      => 'mysql',
#    }
#  }
#
#  node 'wdpuppet04.dj-wasabi.local' {
#    #class { 'postgresql::server':
#    #    listen_addresses => '192.168.20.14'
#    #  }
#      class { 'mysql::server':
#        override_options => {
#          'mysqld'       => {
#            'bind_address' => '192.168.20.14',
#          },
#        },
#      }
#    class { 'zabbix::database':
#      database_type     => 'mysql',
#      zabbix_type       => 'proxy',
#      #zabbix_proxy_ip   => '192.168.20.13',
#      zabbix_proxy      => 'wdpuppet03.dj-wasabi.local',
#      database_name     => 'zabbix-proxy',
#      database_user     => 'zabbix-proxy',
#      database_password => 'zabbix-proxy',
#    }
#  }
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
class zabbix::proxy (
  Zabbix::Databases $database_type                                            = $zabbix::params::database_type,
  $database_path                                                              = $zabbix::params::database_path,
  $zabbix_version                                                             = $zabbix::params::zabbix_version,
  $zabbix_package_state                                                       = $zabbix::params::zabbix_package_state,
  Boolean $manage_database                                                    = $zabbix::params::manage_database,
  Boolean $manage_firewall                                                    = $zabbix::params::manage_firewall,
  Boolean $manage_repo                                                        = $zabbix::params::manage_repo,
  Boolean $manage_resources                                                   = $zabbix::params::manage_resources,
  Boolean $manage_service                                                     = $zabbix::params::manage_service,
  $zabbix_proxy                                                               = $zabbix::params::zabbix_proxy,
  $zabbix_proxy_ip                                                            = $zabbix::params::zabbix_proxy_ip,
  $use_ip                                                                     = $zabbix::params::proxy_use_ip,
  $zbx_templates                                                              = $zabbix::params::proxy_zbx_templates,
  $proxy_configfile_path                                                      = $zabbix::params::proxy_configfile_path,
  $proxy_service_name                                                         = $zabbix::params::proxy_service_name,
  $mode                                                                       = $zabbix::params::proxy_mode,
  $zabbix_server_host                                                         = $zabbix::params::proxy_zabbix_server_host,
  $zabbix_server_port                                                         = $zabbix::params::proxy_zabbix_server_port,
  $hostname                                                                   = $zabbix::params::proxy_hostname,
  $listenport                                                                 = $zabbix::params::proxy_listenport,
  $sourceip                                                                   = $zabbix::params::proxy_sourceip,
  Integer[0] $enableremotecommands                                            = $zabbix::params::proxy_enableremotecommands,
  Integer[0] $logremotecommands                                               = $zabbix::params::proxy_logremotecommands,
  Enum['console', 'file', 'system'] $logtype                                  = $zabbix::params::proxy_logtype,
  Optional[Stdlib::Absolutepath] $logfile                                     = $zabbix::params::proxy_logfile,
  $logfilesize                                                                = $zabbix::params::proxy_logfilesize,
  $debuglevel                                                                 = $zabbix::params::proxy_debuglevel,
  $pidfile                                                                    = $zabbix::params::proxy_pidfile,
  $database_schema_path                                                       = $zabbix::params::database_schema_path,
  $database_host                                                              = $zabbix::params::proxy_database_host,
  $database_name                                                              = $zabbix::params::proxy_database_name,
  $database_schema                                                            = $zabbix::params::proxy_database_schema,
  $database_user                                                              = $zabbix::params::proxy_database_user,
  $database_password                                                          = $zabbix::params::proxy_database_password,
  $database_socket                                                            = $zabbix::params::proxy_database_socket,
  $database_port                                                              = $zabbix::params::proxy_database_port,
  $database_charset                                                           = $zabbix::params::server_database_charset,
  $database_collate                                                           = $zabbix::params::server_database_collate,
  Optional[Enum['required', 'verify_ca', 'verify_full']] $database_tlsconnect = $zabbix::params::proxy_database_tlsconnect,
  Optional[Stdlib::Absolutepath] $database_tlscafile                          = $zabbix::params::proxy_database_tlscafile,
  Optional[Stdlib::Absolutepath] $database_tlscertfile                        = $zabbix::params::proxy_database_tlscertfile,
  Optional[Stdlib::Absolutepath] $database_tlskeyfile                         = $zabbix::params::proxy_database_tlskeyfile,
  Optional[String[1]] $database_tlscipher                                     = $zabbix::params::proxy_database_tlscipher,
  Optional[String[1]] $database_tlscipher13                                   = $zabbix::params::proxy_database_tlscipher13,
  $localbuffer                                                                = $zabbix::params::proxy_localbuffer,
  $offlinebuffer                                                              = $zabbix::params::proxy_offlinebuffer,
  Optional[Enum['disk', 'memory', 'hybrid']] $buffermode                      = $zabbix::params::proxy_buffermode,
  Optional[String[1]] $memorybuffersize                                       = $zabbix::params::proxy_memorybuffersize,
  Optional[Variant[Integer[0], Integer[600, 864000]]] $memorybufferage        = $zabbix::params::proxy_memorybufferage,
  $heartbeatfrequency                                                         = $zabbix::params::proxy_heartbeatfrequency,
  $configfrequency                                                            = $zabbix::params::proxy_configfrequency,
  Optional[Integer[1,604800]] $proxyconfigfrequency                           = $zabbix::params::proxy_proxyconfigfrequency,
  $datasenderfrequency                                                        = $zabbix::params::proxy_datasenderfrequency,
  $startpollers                                                               = $zabbix::params::proxy_startpollers,
  $startipmipollers                                                           = $zabbix::params::proxy_startipmipollers,
  Integer[0, 1000] $startodbcpollers                                          = $zabbix::params::proxy_startodbcpollers,
  $startpollersunreachable                                                    = $zabbix::params::proxy_startpollersunreachable,
  Integer[1, 1000] $startpreprocessors                                        = $zabbix::params::proxy_startpreprocessors,
  $starttrappers                                                              = $zabbix::params::proxy_starttrappers,
  $startpingers                                                               = $zabbix::params::proxy_startpingers,
  $startdiscoverers                                                           = $zabbix::params::proxy_startdiscoverers,
  $starthttppollers                                                           = $zabbix::params::proxy_starthttppollers,
  $javagateway                                                                = $zabbix::params::proxy_javagateway,
  $javagatewayport                                                            = $zabbix::params::proxy_javagatewayport,
  $startjavapollers                                                           = $zabbix::params::proxy_startjavapollers,
  $startvmwarecollectors                                                      = $zabbix::params::proxy_startvmwarecollectors,
  Optional[String[1]] $vaultdbpath                                            = $zabbix::params::proxy_vaultdbpath,
  Optional[String[1]] $vaulttoken                                             = $zabbix::params::proxy_vaulttoken,
  Stdlib::HTTPSUrl $vaulturl                                                  = $zabbix::params::proxy_vaulturl,
  $vmwarefrequency                                                            = $zabbix::params::proxy_vmwarefrequency,
  $vmwareperffrequency                                                        = $zabbix::params::proxy_vmwareperffrequency,
  $vmwarecachesize                                                            = $zabbix::params::proxy_vmwarecachesize,
  $vmwaretimeout                                                              = $zabbix::params::proxy_vmwaretimeout,
  $snmptrapperfile                                                            = $zabbix::params::proxy_snmptrapperfile,
  $snmptrapper                                                                = $zabbix::params::proxy_snmptrapper,
  $listenip                                                                   = $zabbix::params::proxy_listenip,
  $housekeepingfrequency                                                      = $zabbix::params::proxy_housekeepingfrequency,
  $cachesize                                                                  = $zabbix::params::proxy_cachesize,
  $startdbsyncers                                                             = $zabbix::params::proxy_startdbsyncers,
  $historycachesize                                                           = $zabbix::params::proxy_historycachesize,
  $historyindexcachesize                                                      = $zabbix::params::proxy_historyindexcachesize,
  $historytextcachesize                                                       = $zabbix::params::proxy_historytextcachesize,
  $timeout                                                                    = $zabbix::params::proxy_timeout,
  Optional[Variant[Array[Enum['unencrypted','psk','cert']],Enum['unencrypted','psk','cert']]] $tlsaccept = $zabbix::params::proxy_tlsaccept,
  $tlscafile                                                                  = $zabbix::params::proxy_tlscafile,
  $tlscertfile                                                                = $zabbix::params::proxy_tlscertfile,
  $tlsconnect                                                                 = $zabbix::params::proxy_tlsconnect,
  $tlscrlfile                                                                 = $zabbix::params::proxy_tlscrlfile,
  $tlskeyfile                                                                 = $zabbix::params::proxy_tlskeyfile,
  $tlspskfile                                                                 = $zabbix::params::proxy_tlspskfile,
  $tlspskidentity                                                             = $zabbix::params::proxy_tlspskidentity,
  Optional[String[1]] $tlscipherall                                           = $zabbix::params::proxy_tlscipherall,
  Optional[String[1]] $tlscipherall13                                         = $zabbix::params::proxy_tlscipherall13,
  Optional[String[1]] $tlsciphercert                                          = $zabbix::params::proxy_tlsciphercert,
  Optional[String[1]] $tlsciphercert13                                        = $zabbix::params::proxy_tlsciphercert13,
  Optional[String[1]] $tlscipherpsk                                           = $zabbix::params::proxy_tlscipherpsk,
  Optional[String[1]] $tlscipherpsk13                                         = $zabbix::params::proxy_tlscipherpsk13,
  $tlsservercertissuer                                                        = $zabbix::params::proxy_tlsservercertissuer,
  $tlsservercertsubject                                                       = $zabbix::params::proxy_tlsservercertsubject,
  $trappertimeout                                                             = $zabbix::params::proxy_trappertimeout,
  $unreachableperiod                                                          = $zabbix::params::proxy_unreachableperiod,
  $unavaliabledelay                                                           = $zabbix::params::proxy_unavaliabledelay,
  $unreachabedelay                                                            = $zabbix::params::proxy_unreachabedelay,
  $externalscripts                                                            = $zabbix::params::proxy_externalscripts,
  $fpinglocation                                                              = $zabbix::params::proxy_fpinglocation,
  $fping6location                                                             = $zabbix::params::proxy_fping6location,
  $sshkeylocation                                                             = $zabbix::params::proxy_sshkeylocation,
  Optional[String[1]] $statsallowedip                                         = $zabbix::params::proxy_statsallowedip,
  $logslowqueries                                                             = $zabbix::params::proxy_logslowqueries,
  $tmpdir                                                                     = $zabbix::params::proxy_tmpdir,
  $allowroot                                                                  = $zabbix::params::proxy_allowroot,
  $include_dir                                                                = $zabbix::params::proxy_include,
  Optional[Stdlib::Absolutepath] $sslcalocation_dir                           = $zabbix::params::proxy_sslcalocation,
  Optional[Stdlib::Absolutepath] $sslcertlocation_dir                         = $zabbix::params::proxy_sslcertlocation,
  Optional[Stdlib::Absolutepath] $sslkeylocation_dir                          = $zabbix::params::proxy_sslkeylocation,
  $loadmodulepath                                                             = $zabbix::params::proxy_loadmodulepath,
  $loadmodule                                                                 = $zabbix::params::proxy_loadmodule,
  Boolean $manage_selinux                                                     = $zabbix::params::manage_selinux,
  Optional[Stdlib::Absolutepath] $socketdir                                   = $zabbix::params::proxy_socketdir,
) inherits zabbix::params {
  # check osfamily, Arch is currently not supported for web
  if $facts['os']['family'] == 'Archlinux' {
    fail('Archlinux is currently not supported for zabbix::proxy ')
  }

  # Find if listenip is set. If not, we can set to specific ip or
  # to network name. If more than 1 interfaces are available, we
  # can find the ipaddress of this specific interface if listenip
  # is set to for example "eth1" or "bond0.73".
  if ($listenip != undef) {
    if ($listenip =~ /^(eth|lo|bond|lxc|eno|tap|tun).*/) {
      $listen_ip = getvar("::ipaddress_${listenip}")
    } elsif $listenip =~ Stdlib::IP::Address {
      $listen_ip = $listenip
    } else {
      $listen_ip = undef
    }
  } else {
    $listen_ip = undef
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    if String($mode) == '0' {
      # Active proxies don't use `ipaddress`, `use_ip` or `port`.
      class { 'zabbix::resources::proxy':
        hostname => $hostname,
        mode     => $mode,
      }
    } else {
      class { 'zabbix::resources::proxy':
        hostname  => $hostname,
        ipaddress => $listen_ip,
        use_ip    => $use_ip,
        mode      => $mode,
        port      => $listenport,
      }
    }

    zabbix::userparameters { 'Zabbix_Proxy': template => 'Template App Zabbix Proxy', }
  }

  # Get the correct database_type. We need this for installing the
  # correct package and loading the sql files.
  case $database_type {
    'postgresql' : { $db = 'pgsql' }
    'mysql'      : { $db = 'mysql' }
    'sqlite'     : { $db = 'sqlite3' }
    default      : { fail("Unrecognized database type for proxy: ${database_type}") }
  }

  if $manage_database {
    if versioncmp($zabbix_version, '5.4') >= 0 {
      package { 'zabbix-sql-scripts':
        ensure  => present,
        require => Class['zabbix::repo'],
        tag     => 'zabbix',
      }
    }

    # Zabbix version 5.4 uses zabbix-sql-scripts for initializing the database.
    if versioncmp($zabbix_version, '5.4') >= 0 {
      $zabbix_database_require = [Package["zabbix-proxy-${db}"], Package['zabbix-sql-scripts']]
    } else {
      $zabbix_database_require = Package["zabbix-proxy-${db}"]
    }

    case $database_type {
      'postgresql' : {
        # Execute the postgresql scripts
        class { 'zabbix::database::postgresql':
          zabbix_type          => 'proxy',
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
      'mysql'      : {
        # Execute the mysql scripts
        class { 'zabbix::database::mysql':
          zabbix_type          => 'proxy',
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

      'sqlite'      : {}

      default      : {
        fail("Unrecognized database type for proxy: ${database_type}")
      }
    }
  }

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }

    Package["zabbix-proxy-${db}"] {
      require => Class['zabbix::repo']
    }
  }

  # Installing the packages
  package { "zabbix-proxy-${db}":
    ensure => $zabbix_package_state,
    tag    => 'zabbix',
  }

  # Controlling the 'zabbix-proxy' service
  if $manage_service {
    service { $proxy_service_name:
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true,
      subscribe  => [
        File[$proxy_configfile_path],
        Class['zabbix::database']
      ],
      require    => [
        Package["zabbix-proxy-${db}"],
        File[$include_dir],
        File[$proxy_configfile_path],
        Class['zabbix::database']
      ],
    }
  }

  $before_database = $manage_service ? {
    true  => [
      Service[$proxy_service_name],
      Class["zabbix::database::${database_type}"]
    ],
    false => Class["zabbix::database::${database_type}"],
  }

  # if we want to manage the databases, we do
  # some stuff. (for maintaining database only.)
  if $manage_database {
    class { 'zabbix::database':
      database_type     => $database_type,
      zabbix_type       => 'proxy',
      database_name     => $database_name,
      database_user     => $database_user,
      database_password => $database_password,
      database_host     => $database_host,
      database_charset  => $database_charset,
      database_collate  => $database_collate,
      zabbix_proxy      => $zabbix_proxy,
      zabbix_proxy_ip   => $zabbix_proxy_ip,
      before            => $before_database,
    }
  }

  # Configuring the zabbix-proxy configuration file
  file { $proxy_configfile_path:
    ensure  => file,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    require => Package["zabbix-proxy-${db}"],
    replace => true,
    content => template('zabbix/zabbix_proxy.conf.erb'),
  }

  # Include dir for specific zabbix-proxy checks.
  file { $include_dir:
    ensure  => directory,
    require => File[$proxy_configfile_path],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '151 zabbix-proxy':
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

  # check if selinux is active and allow zabbix
  if fact('os.selinux.enabled') == true and $manage_selinux {
    selboolean { 'zabbix_can_network':
      persistent => true,
      value      => 'on',
    }
  }
}
