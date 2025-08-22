# @summary This will install and configure the zabbix-agent deamon
# @param zabbix_version This is the zabbix version.
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param zabbix_package_agent The name of the agent package that we manage
# @param manage_firewall When true, it will create iptables rules.
# @param manage_repo When true, it will create repository for installing the agent.
# @param manage_choco
#   When true on windows, it will use chocolatey to install the agent.
#   The module chocolatey is required https://forge.puppet.com/puppetlabs/chocolatey.
# @param zabbix_package_provider
#   Which package's provider to use to install the agent.
#   It is undef for all linux os and set to 'chocolatey' on windows.
# @param zabbix_package_source
#   Path to a Windows MSI file used to install the agent.
# @param manage_resources
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
# @param monitored_by_proxy
#   When this is monitored by an proxy, please fill in the name of this proxy.
#   If the proxy is also installed via this module, please fill in the FQDN
# @param agent_use_ip
#   When true, when creating hosts via the zabbix-api, it will configure that
#   connection should me made via ip, not fqdn.
# @param zbx_groups An array of hostgroups where this host needs to be added.
# @param zbx_group_create Whether to create hostgroup if missing.
# @param zbx_templates List of templates which will be added when host is configured.
# @param zbx_macros List of macros which will be added when host is configured.
# @param zbx_interface_type Integer specifying type of interface to be created.
# @param zbx_interface_details Hash with interface details for SNMP when interface type is 2.
# @param agent_configfile_path Agent config file path defaults to /etc/zabbix/zabbix_agentd.conf.
# @param pidfile Name of pid file.
# @param servicename Zabbix's agent service name.
# @param logfile Name of log file.
# @param logfilesize Maximum size of log file in MB.
# @param logtype Specifies where log messages are written to. Can be one of: console, file, system.
# @param debuglevel Specifies debug level.
# @param sourceip Source ip address for outgoing connections.
# @param allowkey Allow execution of item keys matching pattern.
# @param denykey Deny execution of items keys matching pattern.
# @param enableremotecommands Whether remote commands from zabbix server are allowed.
# @param logremotecommands Enable logging of executed shell commands as warnings.
# @param server List of comma delimited ip addresses (or hostnames) of zabbix servers.
# @param listenport Agent will listen on this port for connections from the server.
# @param listenip
#   List of comma delimited ip addresses that the agent should listen on.
#   You can also specify which network interface it should listen on.
#
#   listenip => 'eth0',  or
#   listenip => 'bond0.73',
#
#   It will find out which ip is configured for this ipaddress. Can be handy
#   if more than 1 interface is on the server.
#
# @param statusport Agent will listen on this port for HTTP status requests.
# @param startagents Number of pre-forked instances of zabbix_agentd that process passive checks.
# @param serveractive List of comma delimited ip:port (or hostname:port) pairs of zabbix servers for active checks.
# @param service_ensure Start / stop the agent service. E.g. to preconfigure a hosts agent and turn on the service at a later time (when the server reaches production SLA)
# @param service_enable Automatically start the agent on system boot
# @param hostname Unique, case sensitive hostname.
# @param hostnameitem Zabbix item used for generating hostname if it is undefined.
# @param hostmetadata Optional parameter that defines host metadata.
# @param hostmetadataitem Optional parameter that defines a zabbix item used for getting host metadata.
# @param hostinterface
#   Optional parameter that defines host metadata. Host metadata is used only at host
#   auto-registration process (active agent).
# @param hostinterfaceitem
#   Optional parameter that defines an item used for getting host interface.
#   Host interface is used at host auto-registration process.
# @param refreshactivechecks How often list of active checks is refreshed, in seconds.
# @param buffersend Do not keep data longer than n seconds in buffer.
# @param buffersize Maximum number of values in a memory buffer.
# @param enablepersistentbuffer Use persistent buffer (set to 1), or in-memory buffer is used (default).
# @param persistentbufferperiod Zabbix Agent2 will keep data for this time period in case of no connectivity with Zabbix server or proxy.
# @param persistentbufferfile Full filename. Zabbix Agent2 will keep SQLite database in this file.
# @param maxlinespersecond Maximum number of new lines the agent will send per second to zabbix server or proxy processing.
# @param allowroot Allow the agent to run as 'root'.
# @param zabbix_user Drop privileges to a specific, existing user on the system. Only has effect if run as 'root' and AllowRoot is disabled.
# @param zabbix_alias Sets an alias for parameter.
# @param timeout Spend no more than timeout seconds on processing.
# @param tlsaccept What incoming connections to accept from Zabbix server. Used for a passive proxy, ignored on an active proxy.
# @param tlscafile Full pathname of a file containing the top-level CA(s) certificates for peer certificate verification.
# @param tlscertfile Full pathname of a file containing the proxy certificate or certificate chain.
# @param tlscertissuer Issuer of the certificate that is allowed to talk with the serve
# @param tlscertsubject Subject of the certificate that is allowed to talk with the server
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
# @param agent_config_owner The owner of Zabbix's agent config file.
# @param agent_config_group The group of Zabbix's agent config file.
# @param manage_selinux Whether the module should manage SELinux rules or not.
# @param selinux_require An array of SELinux require {} rules.
# @param selinux_rules A Hash of SELinux rules.
# @param additional_service_params Additional parameters to pass to the service.
# @param service_type Systemd service type
# @param include_dir You may include individual files or all files in a directory in the configuration file.
# @param include_dir_purge Include dir to purge.
# @param unsafeuserparameters Allow all characters to be passed in arguments to user-defined parameters.
# @param userparameter User-defined parameter to monitor.
# @param controlsocket The control socket, used to send runtime commands with '-R' option.
# @param loadmodulepath Full path to location of agent modules.
# @param loadmodule Module to load at agent startup.
# @param manage_startup_script
#  If the init script should be managed by this module. Attention: This might
#  cause problems with some config options of this module (e.g
#  agent_configfile_path)
# @example Basic installation:
#  class { 'zabbix::agent':
#    zabbix_version => '6.0',
#    server         => '192.168.1.1',
#  }
#
# @example With exported resources:
#  class { 'zabbix::agent':
#    manage_resources   => true,
#    monitored_by_proxy => 'my_proxy_host',
#    server             => '192.168.1.1',
#  }
#
# @example Using Zabbix Agent 2
#   class { 'zabbix::agent':
#     agent_configfile_path => '/etc/zabbix/zabbix_agent2.conf',
#     include_dir           => '/etc/zabbix/zabbix_agent2.d',
#     include_dir_purge     => false,
#     zabbix_package_agent  => 'zabbix-agent2',
#     servicename           => 'zabbix-agent2',
#     manage_startup_script => false,
#   }
#
# @author Werner Dijkerman ikben@werner-dijkerman.nl
class zabbix::agent (
  $zabbix_version                                      = $zabbix::params::zabbix_version,
  $zabbix_package_state                                = $zabbix::params::zabbix_package_state,
  $zabbix_package_agent                                = $zabbix::params::zabbix_package_agent,
  Optional[String[1]] $zabbix_package_provider         = $zabbix::params::zabbix_package_provider,
  Optional[Stdlib::Windowspath] $zabbix_package_source = undef,
  Boolean $manage_choco                                = $zabbix::params::manage_choco,
  Boolean $manage_firewall                             = $zabbix::params::manage_firewall,
  Boolean $manage_repo                                 = $zabbix::params::manage_repo,
  Boolean $manage_resources                            = $zabbix::params::manage_resources,
  $monitored_by_proxy                                  = $zabbix::params::monitored_by_proxy,
  $agent_use_ip                                        = $zabbix::params::agent_use_ip,
  Variant[String[1],Array[String[1]]] $zbx_groups      = $zabbix::params::agent_zbx_groups,
  $zbx_group_create                                    = $zabbix::params::agent_zbx_group_create,
  $zbx_templates                                       = $zabbix::params::agent_zbx_templates,
  Array[Hash] $zbx_macros                              = [],
  Integer[1,4] $zbx_interface_type                     = 1,
  Variant[Array, Hash] $zbx_interface_details          = [],
  $agent_configfile_path                               = $zabbix::params::agent_configfile_path,
  $pidfile                                             = $zabbix::params::agent_pidfile,
  $servicename                                         = $zabbix::params::agent_servicename,
  Enum['console', 'file', 'system'] $logtype           = $zabbix::params::agent_logtype,
  Optional[Stdlib::Absolutepath] $logfile              = $zabbix::params::agent_logfile,
  $logfilesize                                         = $zabbix::params::agent_logfilesize,
  $debuglevel                                          = $zabbix::params::agent_debuglevel,
  $sourceip                                            = $zabbix::params::agent_sourceip,
  Optional[String[1]] $allowkey                        = $zabbix::params::agent_allowkey,
  Optional[String[1]] $denykey                         = $zabbix::params::agent_denykey,
  $enableremotecommands                                = $zabbix::params::agent_enableremotecommands,
  $logremotecommands                                   = $zabbix::params::agent_logremotecommands,
  $server                                              = $zabbix::params::agent_server,
  $listenport                                          = $zabbix::params::agent_listenport,
  $listenip                                            = $zabbix::params::agent_listenip,
  Optional[Integer[1024,32767]] $statusport            = $zabbix::params::agent_statusport,
  $startagents                                         = $zabbix::params::agent_startagents,
  $serveractive                                        = $zabbix::params::agent_serveractive,
  Stdlib::Ensure::Service $service_ensure              = $zabbix::params::agent_service_ensure,
  Boolean $service_enable                              = $zabbix::params::agent_service_enable,
  $hostname                                            = $zabbix::params::agent_hostname,
  $hostnameitem                                        = $zabbix::params::agent_hostnameitem,
  $hostmetadata                                        = $zabbix::params::agent_hostmetadata,
  $hostmetadataitem                                    = $zabbix::params::agent_hostmetadataitem,
  Optional[Stdlib::Fqdn] $hostinterface                = $zabbix::params::agent_hostinterface,
  Optional[Stdlib::Fqdn] $hostinterfaceitem            = $zabbix::params::agent_hostinterfaceitem,
  $refreshactivechecks                                 = $zabbix::params::agent_refreshactivechecks,
  $buffersend                                          = $zabbix::params::agent_buffersend,
  $buffersize                                          = $zabbix::params::agent_buffersize,
  Optional[Integer[0,1]] $enablepersistentbuffer       = $zabbix::params::agent_enablepersistentbuffer,
  Optional[Stdlib::Absolutepath] $persistentbufferfile = $zabbix::params::agent_persistentbufferfile,
  Optional[String[1]] $persistentbufferperiod          = $zabbix::params::agent_persistentbufferperiod,
  $maxlinespersecond                                   = $zabbix::params::agent_maxlinespersecond,
  Optional[Array] $zabbix_alias                        = $zabbix::params::agent_zabbix_alias,
  $timeout                                             = $zabbix::params::agent_timeout,
  $allowroot                                           = $zabbix::params::agent_allowroot,
  Optional[String[1]] $zabbix_user                     = $zabbix::params::agent_zabbix_user,
  $include_dir                                         = $zabbix::params::agent_include,
  $include_dir_purge                                   = $zabbix::params::agent_include_purge,
  $unsafeuserparameters                                = $zabbix::params::agent_unsafeuserparameters,
  $userparameter                                       = $zabbix::params::agent_userparameter,
  Optional[Stdlib::Absolutepath] $controlsocket        = $zabbix::params::agent_controlsocket,
  Optional[String[1]] $loadmodulepath                  = $zabbix::params::agent_loadmodulepath,
  $loadmodule                                          = $zabbix::params::agent_loadmodule,
  Optional[Variant[Array[Enum['unencrypted','psk','cert']],Enum['unencrypted','psk','cert']]] $tlsaccept = $zabbix::params::agent_tlsaccept,
  $tlscafile                                           = $zabbix::params::agent_tlscafile,
  $tlscertfile                                         = $zabbix::params::agent_tlscertfile,
  Optional[String[1]] $tlscertissuer                   = undef,
  Optional[String[1]] $tlscertsubject                  = undef,
  Optional[String[1]] $tlscipherall                    = $zabbix::params::agent_tlscipherall,
  Optional[String[1]] $tlscipherall13                  = $zabbix::params::agent_tlscipherall13,
  Optional[String[1]] $tlsciphercert                   = $zabbix::params::agent_tlsciphercert,
  Optional[String[1]] $tlsciphercert13                 = $zabbix::params::agent_tlsciphercert13,
  Optional[String[1]] $tlscipherpsk                    = $zabbix::params::agent_tlscipherpsk,
  Optional[String[1]] $tlscipherpsk13                  = $zabbix::params::agent_tlscipherpsk13,
  Optional[Enum['unencrypted','psk','cert']] $tlsconnect = $zabbix::params::agent_tlsconnect,
  $tlscrlfile                                          = $zabbix::params::agent_tlscrlfile,
  $tlskeyfile                                          = $zabbix::params::agent_tlskeyfile,
  $tlspskfile                                          = $zabbix::params::agent_tlspskfile,
  $tlspskidentity                                      = $zabbix::params::agent_tlspskidentity,
  $tlsservercertissuer                                 = $zabbix::params::agent_tlsservercertissuer,
  $tlsservercertsubject                                = $zabbix::params::agent_tlsservercertsubject,
  Optional[String[1]] $agent_config_owner              = $zabbix::params::agent_config_owner,
  Optional[String[1]] $agent_config_group              = $zabbix::params::agent_config_group,
  Boolean $manage_selinux                              = $zabbix::params::manage_selinux,
  Array[String] $selinux_require                       = $zabbix::params::selinux_require,
  Hash[String, Array] $selinux_rules                   = $zabbix::params::selinux_rules,
  String $additional_service_params                    = $zabbix::params::additional_service_params,
  String $service_type                                 = $zabbix::params::service_type,
  Boolean $manage_startup_script                       = $zabbix::params::manage_startup_script,
) inherits zabbix::params {
  $agent2 = $zabbix_package_agent == 'zabbix-agent2'

  # Find if listenip is set. If not, we can set to specific ip or
  # to network name. If more than 1 interfaces are available, we
  # can find the ipaddress of this specific interface if listenip
  # is set to for example "eth1" or "bond0.73".
  $listen_ip = $listenip ? {
    /^(e|lo|bond|lxc|tap|tun|virbr).*/ => fact("networking.interfaces.${listenip}.ip"),
    '*' => undef,
    default => $listenip,
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    if $monitored_by_proxy != '' {
      $use_proxy = $monitored_by_proxy
    } else {
      $use_proxy = ''
    }
    $_hostname = pick($hostname, $facts['networking']['fqdn'])

    class { 'zabbix::resources::agent':
      hostname         => $_hostname,
      ipaddress        => $listen_ip,
      use_ip           => $agent_use_ip,
      port             => $listenport,
      groups           => [$zbx_groups].flatten(),
      group_create     => $zbx_group_create,
      templates        => $zbx_templates,
      macros           => $zbx_macros,
      interfacetype    => $zbx_interface_type,
      interfacedetails => $zbx_interface_details,
      proxy            => $use_proxy,
      tls_accept       => $tlsaccept,
      tls_connect      => $tlsconnect,
      tls_issuer       => $tlscertissuer,
      tls_subject      => $tlscertsubject,
    }
  }

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
  }

  if $facts['kernel'] == 'windows' {
    if $manage_choco {
      package { $zabbix_package_agent:
        ensure   => $zabbix_version,
        provider => $zabbix_package_provider,
        tag      => 'zabbix',
      }
    } else {
      assert_type(Stdlib::Windowspath, $zabbix_package_source)
      package { $zabbix_package_agent:
        ensure          => $zabbix_package_state,
        tag             => 'zabbix',
        provider        => $zabbix_package_provider,
        source          => $zabbix_package_source,
        install_options => "SERVER=${server}",
      }
    }
  }
  else {
    # Installing the package
    package { $zabbix_package_agent:
      ensure   => $zabbix_package_state,
      require  => Class['zabbix::repo'],
      tag      => 'zabbix',
      provider => $zabbix_package_provider,
    }
  }

  # Ensure that the correct config file is used.
  if $manage_startup_script {
    zabbix::startup { $servicename:
      pidfile                   => $pidfile,
      agent_configfile_path     => $agent_configfile_path,
      zabbix_user               => $zabbix_user,
      additional_service_params => $additional_service_params,
      service_type              => $service_type,
      service_name              => 'zabbix-agent',
      require                   => Package[$zabbix_package_agent],
    }
  }

  if $agent_configfile_path != '/etc/zabbix/zabbix_agentd.conf' and $facts['kernel'] != 'windows' {
    file { '/etc/zabbix/zabbix_agentd.conf':
      ensure  => absent,
      require => Package[$zabbix_package_agent],
    }
  }

  $service_require = $manage_startup_script ? {
    true  => [Package[$zabbix_package_agent], Zabbix::Startup[$servicename]],
    false => Package[$zabbix_package_agent]
  }

  # Controlling the 'zabbix-agent' service
  service { $servicename:
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => $service_require,
  }

  # Override the service provider on AIX
  # Doing it this way allows overriding it on other platforms
  if $facts['os']['name'] == 'AIX' {
    Service[$servicename] {
      provider => 'init',
      path     => '/etc/rc.d/init.d',
    }
  }

  # Configuring the zabbix-agent configuration file
  file { $agent_configfile_path:
    ensure  => file,
    owner   => $agent_config_owner,
    group   => $agent_config_group,
    mode    => '0644',
    notify  => Service[$servicename],
    require => Package[$zabbix_package_agent],
    replace => true,
    content => template('zabbix/zabbix_agentd.conf.erb'),
  }

  # Include dir for specific zabbix-agent checks.
  file { $include_dir:
    ensure  => directory,
    owner   => $agent_config_owner,
    group   => $agent_config_group,
    recurse => true,
    purge   => $include_dir_purge,
    notify  => Service[$servicename],
    require => File[$agent_configfile_path],
  }

  # Manage firewall
  if $manage_firewall {
    $servers = split($server, ',')
    $servers.each |$_server| {
      firewall { "150 zabbix-agent from ${_server}":
        dport  => $listenport,
        proto  => 'tcp',
        jump   => 'accept',
        source => $_server,
        state  => [
          'NEW',
          'RELATED',
          'ESTABLISHED',
        ],
      }
    }
  }
  # the agent doesn't work perfectly fine with selinux
  # https://support.zabbix.com/browse/ZBX-11631
  if fact('os.selinux.enabled') == true and $manage_selinux {
    selinux::module { 'zabbix-agent':
      ensure     => 'present',
      content_te => template('zabbix/selinux/zabbix-agent.te.erb'),
      before     => Service[$servicename],
    }
  }
}
