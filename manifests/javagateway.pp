# == Class: zabbix::javagateway
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
#   When true, it will create repository for installing the javagateway.
#
# [*pidfile*]
#   Name of pid file.
#
# [*listenip*]
#   List of comma delimited ip addresses that the agent should listen on.
#
# [*listenport*]
#   Agent will listen on this port for connections from the server.
#
# [*startpollers*]
#   Number of worker threads to start.
#
# === Example
#
#  class { 'zabbix::javagateway':
#    zabbix_version => '2.2',
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
class zabbix::javagateway(
  $zabbix_version  = $zabbix::params::zabbix_version,
  $manage_firewall = $zabbix::params::manage_firewall,
  $manage_repo     = $zabbix::params::manage_repo,
  $pidfile         = $zabbix::params::javagateway_pidfile,
  $listenip        = $zabbix::params::javagateway_listenip,
  $listenport      = $zabbix::params::javagateway_listenport,
  $startpollers    = $zabbix::params::javagateway_startpollers,
) inherits zabbix::params  {

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
    Package['zabbix-java-gateway'] {require => Class['zabbix::repo']}
  }

  # Installing the package
  package { 'zabbix-java-gateway':
    ensure  => present,
  }

  # Configuring the zabbix-javagateway configuration file
  file { '/etc/zabbix/zabbix_java_gateway.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0640',
    notify  => Service['zabbix-java-gateway'],
    require => Package['zabbix-java-gateway'],
    replace => true,
    content => template('zabbix/zabbix_java_gateway.conf.erb'),
  }

  # Workaround for: The redhat provider can not handle attribute enable
  # This is only happening when using an redhat family version 5.x.
  if $::osfamily == 'redhat' and $::operatingsystemrelease !~ /^5.*/ {
    Service['zabbix-java-gateway'] { enable     => true }
  }

  # Controlling the 'zabbix-java-gateway' service
  service { 'zabbix-java-gateway':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['zabbix-java-gateway'],
      File['/etc/zabbix/zabbix_java_gateway.conf']
    ],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '152 zabbix-javagateway':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }
}
