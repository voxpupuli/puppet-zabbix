# == Class: zabbix::agent
#
#  This will install and configure the zabbix-agent deamon
#
# === Requirements
#
# No requirements.
#
# === Parameters
#
# [*zabbix_version*]
#   This is the zabbix version.
#
# [*manage_firewall*]
#   When true, it will create iptables rules.
#
# [*manage_repo*]
#   When true, it will create repository for installing the agent.
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
#   Llist of comma delimited ip addresses (or hostnames) of zabbix servers.
#
# [*listenport*]
#   Agent will listen on this port for connections from the server.
#
# [*listenip*]
#   List of comma delimited ip addresses that the agent should listen on.
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
class zabbix::agent (
  $zabbix_version       = $zabbix::params::zabbix_version,
  $manage_firewall      = $zabbix::params::manage_firewall,
  $manage_repo          = $zabbix::params::manage_repo,
  $pidfile              = $zabbix::params::agent_pidfile,
  $logfile              = $zabbix::params::agent_logfile,
  $logfilesize          = $zabbix::params::agent_logfilesize,
  $debuglevel           = $zabbix::params::agent_debuglevel,
  $sourceip             = $zabbix::params::agent_sourceip,
  $enableremotecommands = $zabbix::params::agent_enableremotecommands,
  $logremotecommands    = $zabbix::params::agent_logremotecommands,
  $server               = $zabbix::params::agent_server,
  $listenport           = $zabbix::params::agent_listenport,
  $listenip             = $zabbix::params::agent_listenip,
  $startagents          = $zabbix::params::agent_startagents,
  $serveractive         = $zabbix::params::agent_serveractive,
  $hostname             = $zabbix::params::agent_hostname,
  $hostnameitem         = $zabbix::params::agent_hostnameitem,
  $hostmetadata         = $zabbix::params::agent_hostmetadata,
  $hostmetadataitem     = $zabbix::params::agent_hostmetadataitem,
  $refreshactivechecks  = $zabbix::params::agent_refreshactivechecks,
  $buffersend           = $zabbix::params::agent_buffersend,
  $buffersize           = $zabbix::params::agent_buffersize,
  $maxlinespersecond    = $zabbix::params::agent_maxlinespersecond,
  $allowroot            = $zabbix::params::agent_allowroot,
  $zabbix_alias         = $zabbix::params::agent_zabbix_alias,
  $timeout              = $zabbix::params::agent_timeout,
  $include_dir          = $zabbix::params::agent_include,
  $unsafeuserparameters = $zabbix::params::agent_unsafeuserparameters,
  $userparameter        = $zabbix::params::agent_userparameter,
  $loadmodulepath       = $zabbix::params::agent_loadmodulepath,
  $loadmodule           = $zabbix::params::agent_loadmodule,
  ) inherits zabbix::params {

  # Check some if they are boolean
  validate_bool($manage_firewall)
  validate_bool($manage_repo)

  # Check if manage_repo is true.
  if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package['zabbix-agent'] {require => Class['zabbix::repo']}
  }

  # Installing the package
  package { 'zabbix-agent':
    ensure  => present,
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
  file { '/etc/zabbix/zabbix_agentd.conf':
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
    purge   => true,
    require => File['/etc/zabbix/zabbix_agentd.conf'],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '150 zabbix-agent':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      source => "${server}/24",
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }
}
