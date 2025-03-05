# @summary This will install and configure the zabbix-server on a single host.
# @param zabbix_url
#   Url on which zabbix needs to be available. Will create an vhost in
#   apache. Only needed when manage_vhost is set to true.
#   Example: zabbix.example.com
# @param zabbix_version This is the zabbix version.
# @param zabbix_timezone The current timezone for vhost configuration needed for the php timezone. Example: Europe/Amsterdam
# @param zabbix_template_dir The directory where all templates are stored before uploading via API
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param zabbix_server
#   This is the FQDN for the host running zabbix-server. This parameter
#   is used when database_type = mysql. Default: localhost
# @param zabbix_server_ip
#   This is the actual ip address of the host running zabbix-server
#   This parameter is used when database_type = postgresql. Default:
#   127.0.0.1
# @param zabbix_web
#   This is the hostname of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   mysql. When single node: localhost
# @param zabbix_web_ip
#   This is the ip address of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   postgresql. When single node: 127.0.0.1
# @param database_type
#   Type of database. Can use the following 2 databases:
#   - postgresql
#   - mysql
# @param database_path
#   When database binaries are not found on the default path:
#   /bin:/usr/bin:/usr/local/sbin:/usr/local/bin
#   you can use this parameter to add the database_path to the above mentioned
#   path.
# @param manage_database When true, it will configure the database and execute the sql scripts.
# @param manage_repo When true (default) this module will manage the Zabbix repository.
# @param manage_firewall When true, it will create iptables rules.
# @param manage_service
#   When true, it will ensure service running and enabled.
#   When false, it does not care about service
# @param manage_resources
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
# @param manage_vhost When true, it will create an vhost for apache. The parameter zabbix_url has to be set.
# @param default_vhost
#   When true priority of 15 is passed to zabbix vhost which would end up
#   with marking zabbix vhost as default one, when false priority is set to 25
# @param apache_use_ssl
#   Will create an ssl vhost. Also nonssl vhost will be created for redirect
#   nonssl to ssl vhost.
# @param apache_ssl_cert
#   The location of the ssl certificate file. You'll need to make sure this
#   file is present on the system, this module will not install this file.
# @param apache_ssl_key
#   The location of the ssl key file. You'll need to make sure this file is
#   present on the system, this module will not install this file.
# @param apache_ssl_cipher
#   The ssl cipher used. Cipher is used from this website:
#   https://wiki.mozilla.org/Security/Server_Side_TLS
# @param apache_ssl_chain The ssl chain file.
# @param apache_listen_ip The IP the apache service should listen on.
# @param apache_listenport The port for the apache vhost.
# @param apache_listenport_ssl The port for the apache SSL vhost.
# @param apache_php_max_execution_time Max execution time for php. Default: 300
# @param apache_php_memory_limit PHP memory size limit. Default: 128M
# @param apache_php_post_max_size PHP maximum post size data. Default: 16M
# @param apache_php_upload_max_filesize PHP maximum upload filesize. Default: 2M
# @param apache_php_max_input_time Max input time for php. Default: 300
# @param apache_php_always_populate_raw_post_data Default: -1
# @param ldap_cacert Set location of ca_cert used by LDAP authentication.
# @param ldap_clientcert Set location of client cert used by LDAP authentication.
# @param ldap_clientkey Set location of client key used by LDAP authentication.
# @param ldap_reqcert Specifies what checks to perform on a server certificate
# @param zabbix_api_user Name of the user which the api should connect to. Default: Admin
# @param zabbix_api_pass Password of the user which connects to the api. Default: zabbix
# @param zabbix_api_access Which host has access to the api. Default: no restriction
# @param listenport Listen port for the zabbix-server. Default: 10051
# @param sourceip Source ip address for outgoing connections.
# @param logfile Name of log file.
# @param logfilesize Maximum size of log file in MB.
# @param logtype Specifies where log messages are written to. (options: console, file, system)
# @param debuglevel Specifies debug level.
# @param pidfile Name of pid file.
# @param database_host Database host name.
# @param database_name Database name.
# @param database_schema Schema name. used for ibm db2.
# @param database_double_ieee754
#   Enable extended range of float values for new installs of Zabbix >= 5.0 and
#   after patching upgraded installs to 5.0 or greater.
#   https://www.zabbix.com/documentation/5.0/manual/installation/upgrade_notes_500#enabling_extended_range_of_numeric_float_values
# @param database_user Database user. ignored for sqlite.
# @param database_password Database password. ignored for sqlite.
# @param database_socket Path to mysql socket.
# @param database_port Database port when not using local socket. Ignored for sqlite.
# @param database_charset The default charset of the database.
# @param database_collate The default collation of the database.
# @param database_tablespace The tablespace the database will be created in. This setting only affects PostgreSQL databases.
# @param database_tlsconnect
#   Available options:
#   * required - connect using TLS
#   * verify_ca - connect using TLS and verify certificate
#   * verify_full - connect using TLS, verify certificate and verify that database identity specified by DBHost matches its certificate
# @param database_tlscafile Full pathname of a file containing the top-level CA(s) certificates for database certificate verification.
# @param startpollers Number of pre-forked instances of pollers.
# @param startagentpollers Number of pre-forked instances of asynchronous Zabbix agent pollers. Also see MaxConcurrentChecksPerPoller.
# @param starthttpagentpollers Number of pre-forked instances of asynchronous HTTP agent pollers. Also see MaxConcurrentChecksPerPoller.
# @param startsnmppollers Number of pre-forked instances of asynchronous SNMP pollers. Also see MaxConcurrentChecksPerPoller.
# @param maxconcurrentchecksperpoller Maximum number of asynchronous checks that can be executed at once by each HTTP agent poller or agent poller.
# @param startpreprocessors Number of pre-forked instances of preprocessing workers
# @param startipmipollers Number of pre-forked instances of ipmi pollers.
# @param startodbcpollers Number of pre-forked instances of ODBC pollers.
# @param startpollersunreachable Number of pre-forked instances of pollers for unreachable hosts (including ipmi).
# @param starthistorypollers
#   Number of pre-forked instances of history pollers.
#   Only required for calculated checks.
#   A database connection is required for each history poller instance.
# @param starttrappers Number of pre-forked instances of trappers.
# @param startpingers Number of pre-forked instances of icmp pingers.
# @param startalerters Number of pre-forked instances of alerters.
# @param startdiscoverers Number of pre-forked instances of discoverers.
# @param startescalators Number of pre-forked instances of escalators.
# @param starthttppollers Number of pre-forked instances of http pollers.
# @param starttimers Number of pre-forked instances of timers.
# @param javagateway IP address (or hostname) of zabbix java gateway.
# @param javagatewayport Port that zabbix java gateway listens on.
# @param smsdevices Devices to use for sms texting
# @param startjavapollers Number of pre-forked instances of java pollers.
# @param startlldprocessors Number of pre-forked instances of low-level discovery (LLD) workers.
# @param startvmwarecollectors Number of pre-forked vmware collector instances.
# @param vaultdbpath Vault path from where credentials for database will be retrieved by keys 'password' and 'username'.
# @param vaulttoken
#   Vault authentication token that should have been generated exclusively for Zabbix proxy with read-only
#   permission to the path specified in the optional VaultDBPath configuration parameter.
# @param vaulturl Vault server HTTP[S] URL. System-wide CA certificates directory will be used if SSLCALocation is not specified.
# @param vmwarefrequency How often zabbix will connect to vmware service to obtain a new datan.
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
# @param startdbsyncers Number of pre-forked instances of db syncers.
# @param historycachesize Size of history cache, in bytes.
# @param historyindexcachesize Size of history index cache, in bytes.
# @param trendcachesize Size of trend cache, in bytes.
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
# @param loadmodulepath Full path to location of server modules.
# @param loadmodule Module to load at server startup.
# @param socketdir
#   IPC socket directory.
#   Directory to store IPC sockets used by internal Zabbix services.
# @param manage_selinux Whether we should manage SELinux rules.
# @param additional_service_params Additional parameters to pass to the service.
# @param zabbix_user User the zabbix service will run as.
# @param zabbix_server_name
#   The fqdn name of the host running the zabbix-server. When single node:
#   localhost
#   This can also be used to upave a different name such as "Zabbix DEV"
# @param saml_sp_key The location of the SAML Service Provider Key file.
# @param saml_sp_cert The location of the SAML Service Provider Certificate.
# @param saml_idp_cert The location of the SAML Identity Provider Certificate.
# @param saml_settings A hash of additional SAML SSO settings.
# @example Single host setup:
#   class { 'zabbix':
#     zabbix_url => 'zabbix.dj-wasabi.nl',
#   }
#
# @example This assumes that you want to use the postgresql database. If not and  you want to supply your own database crendentials:
#   class { 'zabbix':
#     zabbix_url        => 'zabbix.dj-wasabi.nl',
#     database_type     => 'mysql',
#     database_user     => 'zabbix',
#     database_password => 'ThisIsVeryDifficult.nl',
#   }
# @author Werner Dijkerman ikben@werner-dijkerman.nl
class zabbix (
  $zabbix_url                                                                 = '',
  $zabbix_version                                                             = $zabbix::params::zabbix_version,
  $zabbix_package_state                                                       = $zabbix::params::zabbix_package_state,
  $zabbix_timezone                                                            = $zabbix::params::zabbix_timezone,
  $zabbix_web                                                                 = $zabbix::params::zabbix_web,
  $zabbix_server                                                              = $zabbix::params::zabbix_server,
  $zabbix_server_ip                                                           = $zabbix::params::zabbix_server_ip,
  $zabbix_template_dir                                                        = $zabbix::params::zabbix_template_dir,
  $zabbix_web_ip                                                              = $zabbix::params::zabbix_web_ip,
  Zabbix::Databases $database_type                                            = $zabbix::params::database_type,
  $database_path                                                              = $zabbix::params::database_path,
  $manage_database                                                            = $zabbix::params::manage_database,
  $default_vhost                                                              = $zabbix::params::default_vhost,
  $manage_vhost                                                               = $zabbix::params::manage_vhost,
  $manage_firewall                                                            = $zabbix::params::manage_firewall,
  $manage_repo                                                                = $zabbix::params::manage_repo,
  $manage_resources                                                           = $zabbix::params::manage_resources,
  $manage_service                                                             = $zabbix::params::manage_service,
  $apache_use_ssl                                                             = $zabbix::params::apache_use_ssl,
  $apache_ssl_cert                                                            = $zabbix::params::apache_ssl_cert,
  $apache_ssl_key                                                             = $zabbix::params::apache_ssl_key,
  $apache_ssl_cipher                                                          = $zabbix::params::apache_ssl_cipher,
  $apache_ssl_chain                                                           = $zabbix::params::apache_ssl_chain,
  $apache_listen_ip                                                           = $zabbix::params::apache_listen_ip,
  Variant[Array[Stdlib::Port], Stdlib::Port] $apache_listenport               = $zabbix::params::apache_listenport,
  Variant[Array[Stdlib::Port], Stdlib::Port] $apache_listenport_ssl           = $zabbix::params::apache_listenport_ssl,
  $apache_php_max_execution_time                                              = $zabbix::params::apache_php_max_execution_time,
  $apache_php_memory_limit                                                    = $zabbix::params::apache_php_memory_limit,
  $apache_php_post_max_size                                                   = $zabbix::params::apache_php_post_max_size,
  $apache_php_upload_max_filesize                                             = $zabbix::params::apache_php_upload_max_filesize,
  $apache_php_max_input_time                                                  = $zabbix::params::apache_php_max_input_time,
  $apache_php_always_populate_raw_post_data                                   = $zabbix::params::apache_php_always_populate_raw_post_data,
  Optional[Stdlib::Absolutepath] $ldap_cacert                                 = $zabbix::params::ldap_cacert,
  Optional[Stdlib::Absolutepath] $ldap_clientcert                             = $zabbix::params::ldap_clientcert,
  Optional[Stdlib::Absolutepath] $ldap_clientkey                              = $zabbix::params::ldap_clientkey,
  Optional[Enum['never', 'allow', 'try', 'demand', 'hard']] $ldap_reqcert     = $zabbix::params::ldap_reqcert,
  $zabbix_api_user                                                            = $zabbix::params::server_api_user,
  $zabbix_api_pass                                                            = $zabbix::params::server_api_pass,
  Optional[Array[Stdlib::Host,1]] $zabbix_api_access                          = $zabbix::params::server_api_access,
  $listenport                                                                 = $zabbix::params::server_listenport,
  $sourceip                                                                   = $zabbix::params::server_sourceip,
  Enum['console', 'file', 'system'] $logtype                                  = $zabbix::params::server_logtype,
  Optional[Stdlib::Absolutepath] $logfile                                     = $zabbix::params::server_logfile,
  $logfilesize                                                                = $zabbix::params::server_logfilesize,
  $debuglevel                                                                 = $zabbix::params::server_debuglevel,
  $pidfile                                                                    = $zabbix::params::server_pidfile,
  $database_host                                                              = $zabbix::params::server_database_host,
  $database_name                                                              = $zabbix::params::server_database_name,
  $database_schema                                                            = $zabbix::params::server_database_schema,
  Boolean $database_double_ieee754                                            = $zabbix::params::server_database_double_ieee754,
  $database_user                                                              = $zabbix::params::server_database_user,
  $database_password                                                          = $zabbix::params::server_database_password,
  $database_socket                                                            = $zabbix::params::server_database_socket,
  $database_port                                                              = $zabbix::params::server_database_port,
  $database_charset                                                           = $zabbix::params::server_database_charset,
  $database_collate                                                           = $zabbix::params::server_database_collate,
  $database_tablespace                                                        = $zabbix::params::server_database_tablespace,
  Optional[Enum['required', 'verify_ca', 'verify_full']] $database_tlsconnect = $zabbix::params::server_database_tlsconnect,
  Optional[Stdlib::Absolutepath] $database_tlscafile                          = $zabbix::params::server_database_tlscafile,
  Integer[0, 1000] $startpollers                                              = $zabbix::params::server_startpollers,
  Integer[0, 1000] $startagentpollers                                         = $zabbix::params::server_startagentpollers,
  Integer[0, 1000] $starthttpagentpollers                                     = $zabbix::params::server_starthttpagentpollers,
  Integer[0, 1000] $startsnmppollers                                          = $zabbix::params::server_startsnmppollers,
  Integer[0, 1000] $maxconcurrentchecksperpoller                              = $zabbix::params::server_maxconcurrentchecksperpoller,
  Integer[0, 1000] $startipmipollers                                          = $zabbix::params::server_startipmipollers,
  Integer[0, 1000] $startodbcpollers                                          = $zabbix::params::server_startodbcpollers,
  Integer[0, 1000] $startpollersunreachable                                   = $zabbix::params::server_startpollersunreachable,
  Integer[0, 1000] $starthistorypollers                                       = $zabbix::params::server_starthistorypollers,
  Integer[1, 1000] $startpreprocessors                                        = $zabbix::params::server_startpreprocessors,
  $starttrappers                                                              = $zabbix::params::server_starttrappers,
  $startpingers                                                               = $zabbix::params::server_startpingers,
  Integer[1, 100] $startalerters                                              = $zabbix::params::server_startalerters,
  $startdiscoverers                                                           = $zabbix::params::server_startdiscoverers,
  Integer[1, 100] $startescalators                                            = $zabbix::params::server_startescalators,
  $starthttppollers                                                           = $zabbix::params::server_starthttppollers,
  $starttimers                                                                = $zabbix::params::server_starttimers,
  $javagateway                                                                = $zabbix::params::server_javagateway,
  $javagatewayport                                                            = $zabbix::params::server_javagatewayport,
  $startjavapollers                                                           = $zabbix::params::server_startjavapollers,
  Integer[1, 100] $startlldprocessors                                         = $zabbix::params::server_startlldprocessors,
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
  Optional[Variant[String[1],Array[String[1]]]] $smsdevices                   = $zabbix::params::server_smsdevices,
  $historycachesize                                                           = $zabbix::params::server_historycachesize,
  Zabbix::Historyics $historyindexcachesize                                   = $zabbix::params::server_historyindexcachesize,
  $trendcachesize                                                             = $zabbix::params::server_trendcachesize,
  $valuecachesize                                                             = $zabbix::params::server_valuecachesize,
  $timeout                                                                    = $zabbix::params::server_timeout,
  $tlscafile                                                                  = $zabbix::params::server_tlscafile,
  $tlscertfile                                                                = $zabbix::params::server_tlscertfile,
  $tlscrlfile                                                                 = $zabbix::params::server_tlscrlfile,
  $tlskeyfile                                                                 = $zabbix::params::server_tlskeyfile,
  $tlscipherall                                                               = $zabbix::params::server_tlscipherall,
  $tlscipherall13                                                             = $zabbix::params::server_tlscipherall13,
  $tlsciphercert                                                              = $zabbix::params::server_tlsciphercert,
  $tlsciphercert13                                                            = $zabbix::params::server_tlsciphercert13,
  $tlscipherpsk                                                               = $zabbix::params::server_tlscipherpsk,
  $tlscipherpsk13                                                             = $zabbix::params::server_tlscipherpsk13,
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
  Optional[Stdlib::Absolutepath] $socketdir                                   = $zabbix::params::server_socketdir,
  Boolean $manage_selinux                                                     = $zabbix::params::manage_selinux,
  String $additional_service_params                                           = $zabbix::params::additional_service_params,
  Optional[String[1]] $zabbix_user                                            = $zabbix::params::server_zabbix_user,
  Optional[String] $zabbix_server_name                                        = $zabbix::params::zabbix_server,
  Optional[Stdlib::Absolutepath] $saml_sp_key                                 = $zabbix::params::saml_sp_key,
  Optional[Stdlib::Absolutepath] $saml_sp_cert                                = $zabbix::params::saml_sp_cert,
  Optional[Stdlib::Absolutepath] $saml_idp_cert                               = $zabbix::params::saml_idp_cert,
  Hash[String[1], Variant[ScalarData, Hash]] $saml_settings                   = $zabbix::params::saml_settings,
) inherits zabbix::params {
  class { 'zabbix::web':
    zabbix_url                               => $zabbix_url,
    database_type                            => $database_type,
    manage_repo                              => $manage_repo,
    zabbix_version                           => $zabbix_version,
    zabbix_package_state                     => $zabbix_package_state,
    zabbix_timezone                          => $zabbix_timezone,
    zabbix_template_dir                      => $zabbix_template_dir,
    default_vhost                            => $default_vhost,
    manage_vhost                             => $manage_vhost,
    manage_resources                         => $manage_resources,
    apache_use_ssl                           => $apache_use_ssl,
    apache_ssl_cert                          => $apache_ssl_cert,
    apache_ssl_key                           => $apache_ssl_key,
    apache_ssl_cipher                        => $apache_ssl_cipher,
    apache_ssl_chain                         => $apache_ssl_chain,
    apache_listen_ip                         => $apache_listen_ip,
    apache_listenport                        => $apache_listenport,
    apache_listenport_ssl                    => $apache_listenport_ssl,
    zabbix_api_user                          => $zabbix_api_user,
    zabbix_api_pass                          => $zabbix_api_pass,
    zabbix_api_access                        => $zabbix_api_access,
    database_host                            => $database_host,
    database_name                            => $database_name,
    database_schema                          => $database_schema,
    database_double_ieee754                  => $database_double_ieee754,
    database_user                            => $database_user,
    database_password                        => $database_password,
    database_socket                          => $database_socket,
    database_port                            => $database_port,
    zabbix_server                            => $zabbix_server,
    zabbix_server_name                       => $zabbix_server_name,
    zabbix_listenport                        => $listenport,
    apache_php_max_execution_time            => $apache_php_max_execution_time,
    apache_php_memory_limit                  => $apache_php_memory_limit,
    apache_php_post_max_size                 => $apache_php_post_max_size,
    apache_php_upload_max_filesize           => $apache_php_upload_max_filesize,
    apache_php_max_input_time                => $apache_php_max_input_time,
    apache_php_always_populate_raw_post_data => $apache_php_always_populate_raw_post_data,
    ldap_cacert                              => $ldap_cacert,
    ldap_clientcert                          => $ldap_clientcert,
    ldap_clientkey                           => $ldap_clientkey,
    ldap_reqcert                             => $ldap_reqcert,
    saml_sp_key                              => $saml_sp_key,
    saml_sp_cert                             => $saml_sp_cert,
    saml_idp_cert                            => $saml_idp_cert,
    saml_settings                            => $saml_settings,
    manage_selinux                           => $manage_selinux,
    require                                  => Class['zabbix::server'],
  }

  class { 'zabbix::server':
    database_type                => $database_type,
    database_path                => $database_path,
    zabbix_version               => $zabbix_version,
    zabbix_package_state         => $zabbix_package_state,
    manage_firewall              => $manage_firewall,
    manage_repo                  => $manage_repo,
    manage_database              => $manage_database,
    manage_service               => $manage_service,
    listenport                   => $listenport,
    sourceip                     => $sourceip,
    logfile                      => $logfile,
    logfilesize                  => $logfilesize,
    logtype                      => $logtype,
    debuglevel                   => $debuglevel,
    pidfile                      => $pidfile,
    database_host                => $database_host,
    database_name                => $database_name,
    database_schema              => $database_schema,
    database_user                => $database_user,
    database_password            => $database_password,
    database_socket              => $database_socket,
    database_port                => $database_port,
    database_tlsconnect          => $database_tlsconnect,
    database_tlscafile           => $database_tlscafile,
    startpollers                 => $startpollers,
    startagentpollers            => $startagentpollers,
    starthttpagentpollers        => $starthttpagentpollers,
    startsnmppollers             => $startsnmppollers,
    maxconcurrentchecksperpoller => $maxconcurrentchecksperpoller,
    startipmipollers             => $startipmipollers,
    startodbcpollers             => $startodbcpollers,
    startpollersunreachable      => $startpollersunreachable,
    starthistorypollers          => $starthistorypollers,
    startpreprocessors           => $startpreprocessors,
    starttrappers                => $starttrappers,
    startpingers                 => $startpingers,
    startalerters                => $startalerters,
    startdiscoverers             => $startdiscoverers,
    startescalators              => $startescalators,
    starthttppollers             => $starthttppollers,
    starttimers                  => $starttimers,
    javagateway                  => $javagateway,
    javagatewayport              => $javagatewayport,
    startjavapollers             => $startjavapollers,
    startlldprocessors           => $startlldprocessors,
    startvmwarecollectors        => $startvmwarecollectors,
    vaultdbpath                  => $vaultdbpath,
    vaulttoken                   => $vaulttoken,
    vaulturl                     => $vaulturl,
    vmwarefrequency              => $vmwarefrequency,
    vmwarecachesize              => $vmwarecachesize,
    vmwaretimeout                => $vmwaretimeout,
    snmptrapperfile              => $snmptrapperfile,
    startsnmptrapper             => $startsnmptrapper,
    listenip                     => $listenip,
    housekeepingfrequency        => $housekeepingfrequency,
    maxhousekeeperdelete         => $maxhousekeeperdelete,
    cachesize                    => $cachesize,
    cacheupdatefrequency         => $cacheupdatefrequency,
    startdbsyncers               => $startdbsyncers,
    historycachesize             => $historycachesize,
    trendcachesize               => $trendcachesize,
    historyindexcachesize        => $historyindexcachesize,
    valuecachesize               => $valuecachesize,
    timeout                      => $timeout,
    tlscafile                    => $tlscafile,
    tlscertfile                  => $tlscertfile,
    tlscrlfile                   => $tlscrlfile,
    tlskeyfile                   => $tlskeyfile,
    tlscipherall                 => $tlscipherall,
    tlscipherall13               => $tlscipherall13,
    tlsciphercert                => $tlsciphercert,
    tlsciphercert13              => $tlsciphercert13,
    tlscipherpsk                 => $tlscipherpsk,
    tlscipherpsk13               => $tlscipherpsk13,
    trappertimeout               => $trappertimeout,
    unreachableperiod            => $unreachableperiod,
    unavailabledelay             => $unavailabledelay,
    unreachabledelay             => $unreachabledelay,
    alertscriptspath             => $alertscriptspath,
    externalscripts              => $externalscripts,
    fpinglocation                => $fpinglocation,
    fping6location               => $fping6location,
    sshkeylocation               => $sshkeylocation,
    logslowqueries               => $logslowqueries,
    tmpdir                       => $tmpdir,
    startproxypollers            => $startproxypollers,
    proxyconfigfrequency         => $proxyconfigfrequency,
    proxydatafrequency           => $proxydatafrequency,
    allowroot                    => $allowroot,
    include_dir                  => $include_dir,
    loadmodulepath               => $loadmodulepath,
    loadmodule                   => $loadmodule,
    manage_selinux               => $manage_selinux,
    additional_service_params    => $additional_service_params,
    require                      => Class['zabbix::database'],
  }

  class { 'zabbix::database':
    zabbix_type         => 'server',
    zabbix_web          => $zabbix_web,
    zabbix_server       => $zabbix_server,
    zabbix_web_ip       => $zabbix_web_ip,
    zabbix_server_ip    => $zabbix_server_ip,
    manage_database     => $manage_database,
    database_type       => $database_type,
    database_name       => $database_name,
    database_user       => $database_user,
    database_password   => $database_password,
    database_host       => $database_host,
    database_charset    => $database_charset,
    database_collate    => $database_collate,
    database_tablespace => $database_tablespace,
  }
}
