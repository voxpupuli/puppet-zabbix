# == Class: zabbix::agent
#
#  This will install and configure the zabbix-agent deamon
#
# === Requirements
#
#  If 'manage_resources' is set to true, you'll need to configure
#  storeconfigs/exported resources.
#
#  Otherwise no requirements.
#
# === Parameters
#
# [*zabbix_version*]
#   This is the zabbix version.
#
# [*zabbix_package_state*]
#   The state of the package that needs to be installed: present or latest.
#   Default: present
#
# [*manage_firewall*]
#   When true, it will create iptables rules.
#
# [*manage_repo*]
#   When true, it will create repository for installing the agent.
#
# [*manage_resources*]
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
#
# [*monitored_by_proxy*]
#   When this is monitored by an proxy, please fill in the name of this proxy.
#   If the proxy is also installed via this module, please fill in the FQDN
#
# [*agent_use_ip*]
#   When true, when creating hosts via the zabbix-api, it will configure that
#   connection should me made via ip, not fqdn.
#
# [*zbx_group*]
#   Name of thehostgroup where this host needs to be added.
#
# [*zbx_templates*]
#   List of templates which will be added when host is configured.
#
# [*agent_configfile_path*]
#   Agent config file path defaults to /etc/zabbix/zabbix_agentd.conf
#
# [*pidfile*]
#   Name of pid file.
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
# [*sourceip*]
#   Source ip address for outgoing connections.
#
# [*enableremotecommands*]
#   Whether remote commands from zabbix server are allowed.
#
# [*logremotecommands*]
#   Enable logging of executed shell commands as warnings.
#
# [*server*]
#   List of comma delimited ip addresses (or hostnames) of zabbix servers.
#
# [*listenport*]
#   Agent will listen on this port for connections from the server.
#
# [*listenip*]
#   List of comma delimited ip addresses that the agent should listen on.
#   You can also specify which network interface it should listen on.
#
#   Example:
#   listenip => 'eth0',  or
#   listenip => 'bond0.73',
#
#   It will find out which ip is configured for this ipaddress. Can be handy
#   if more than 1 interface is on the server.
#
# [*startagents*]
#   Number of pre-forked instances of zabbix_agentd that process passive checks.
#
# [*serveractive*]
#   List of comma delimited ip:port (or hostname:port) pairs of zabbix servers for active checks.
#
# [*hostname*]
#   Unique, case sensitive hostname.
#
# [*hostnameitem*]
#   Item used for generating hostname if it is undefined.
#
# [*hostmetadata*]
#   Optional parameter that defines host metadata.
#
# [*hostmetadataitem*]
#   Optional parameter that defines an item used for getting host metadata.
#
# [*refreshactivechecks*]
#   How often list of active checks is refreshed, in seconds.
#
# [*buffersend*]
#   Do not keep data longer than n seconds in buffer.
#
# [*buffersize*]
#   Maximum number of values in a memory buffer.
#
# [*maxlinespersecond*]
#   Maximum number of new lines the agent will send per second to zabbix server
#   or proxy processing.
#
# [*allowroot*]
#   Allow the agent to run as 'root'.
#
# [*zabbix_alias*]
#   Sets an alias for parameter.
#
# [*timeout*]
#   Spend no more than timeout seconds on processing.
#
# [*include_dir*]
#   You may include individual files or all files in a directory in the configuration file.
#
# [*unsafeuserparameters*]
#   Allow all characters to be passed in arguments to user-defined parameters.
#
# [*userparameter*]
#   User-defined parameter to monitor.
#
# [*loadmodulepath*]
#   Full path to location of agent modules.
#
# [*loadmodule*]
#   Module to load at agent startup.
#
# === Example
#
#  Basic installation:
#  class { 'zabbix::agent':
#    zabbix_version => '2.2',
#    server         => '192.168.1.1',
#  }
#
#  Exported resources:
#  class { 'zabbix::agent':
#    manage_resources   => true,
#    monitored_by_proxy => 'my_proxy_host',
#    server             => '192.168.1.1',
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
class zabbix::agent (
  $zabbix_version        = $zabbix::params::zabbix_version,
  $zabbix_package_state  = $zabbix::params::zabbix_package_state,
  $manage_firewall       = $zabbix::params::manage_firewall,
  $manage_repo           = $zabbix::params::manage_repo,
  $manage_resources      = $zabbix::params::manage_resources,
  $monitored_by_proxy    = $zabbix::params::monitored_by_proxy,
  $agent_use_ip          = $zabbix::params::agent_use_ip,
  $zbx_group             = $zabbix::params::agent_zbx_group,
  $zbx_group_create      = $zabbix::params::agent_zbx_group_create,
  $zbx_templates         = $zabbix::params::agent_zbx_templates,
  $agent_configfile_path = $zabbix::params::agent_configfile_path,
  $pidfile               = $zabbix::params::agent_pidfile,
  $logfile               = $zabbix::params::agent_logfile,
  $logfilesize           = $zabbix::params::agent_logfilesize,
  $debuglevel            = $zabbix::params::agent_debuglevel,
  $sourceip              = $zabbix::params::agent_sourceip,
  $enableremotecommands  = $zabbix::params::agent_enableremotecommands,
  $logremotecommands     = $zabbix::params::agent_logremotecommands,
  $server                = $zabbix::params::agent_server,
  $listenport            = $zabbix::params::agent_listenport,
  $listenip              = $zabbix::params::agent_listenip,
  $startagents           = $zabbix::params::agent_startagents,
  $serveractive          = $zabbix::params::agent_serveractive,
  $hostname              = $zabbix::params::agent_hostname,
  $hostnameitem          = $zabbix::params::agent_hostnameitem,
  $hostmetadata          = $zabbix::params::agent_hostmetadata,
  $hostmetadataitem      = $zabbix::params::agent_hostmetadataitem,
  $refreshactivechecks   = $zabbix::params::agent_refreshactivechecks,
  $buffersend            = $zabbix::params::agent_buffersend,
  $buffersize            = $zabbix::params::agent_buffersize,
  $maxlinespersecond     = $zabbix::params::agent_maxlinespersecond,
  $allowroot             = $zabbix::params::agent_allowroot,
  $zabbix_alias          = $zabbix::params::agent_zabbix_alias,
  $timeout               = $zabbix::params::agent_timeout,
  $include_dir           = $zabbix::params::agent_include,
  $include_dir_purge     = $zabbix::params::agent_include_purge,
  $unsafeuserparameters  = $zabbix::params::agent_unsafeuserparameters,
  $userparameter         = $zabbix::params::agent_userparameter,
  $loadmodulepath        = $zabbix::params::agent_loadmodulepath,
  $loadmodule            = $zabbix::params::agent_loadmodule,
  ) inherits zabbix::params {

  # Check some if they are boolean
  validate_bool($manage_firewall)
  validate_bool($manage_repo)
  validate_bool($manage_resources)

  # Find if listenip is set. If not, we can set to specific ip or
  # to network name. If more than 1 interfaces are available, we
  # can find the ipaddress of this specific interface if listenip
  # is set to for example "eth1" or "bond0.73".
  if ($listenip != undef) {
    if ($listenip =~ /^(eth|bond|lxc|eno).*/) {
      $int_name = "ipaddress_${listenip}"
      $listen_ip = inline_template('<%= scope.lookupvar(int_name) %>')
    } elsif is_ip_address($listenip) {
      $listen_ip = $listenip
    } else {
      $listen_ip = $::ipaddress
    }
  } else {
    $listen_ip = $::ipaddress
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    if $monitored_by_proxy != ''{
      $use_proxy = $monitored_by_proxy
    } else {
      $use_proxy = ''
    }

    class { 'zabbix::resources::agent':
      hostname     => $::fqdn,
      ipaddress    => $listen_ip,
      use_ip       => $agent_use_ip,
      port         => $listenport,
      group        => $zbx_group,
      group_create => $zbx_group_create,
      templates    => $zbx_templates,
      proxy        => $use_proxy,
    }
  }

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class {'zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
  }

  # Installing the package
  package { 'zabbix-agent':
    ensure  => $zabbix_package_state,
    require => Class['zabbix::repo'],
  }

  # Controlling the 'zabbix-agent' service
  service { 'zabbix-agent':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['zabbix-agent'],
  }

  # Configuring the zabbix-agent configuration file
  file { $agent_configfile_path:
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-agent'],
    require => Package['zabbix-agent'],
    replace => true,
    content => template('zabbix/zabbix_agentd.conf.erb'),
  }

  # Include dir for specific zabbix-agent checks.
  file { $include_dir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    recurse => true,
    purge   => $include_dir_purge,
    notify  => Service['zabbix-agent'],
    require => File[$agent_configfile_path],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '150 zabbix-agent':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      source => $server,
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }
}
