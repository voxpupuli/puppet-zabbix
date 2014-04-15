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
) {

  # Check some if they are boolean
  validate_bool($manage_firewall)
  validate_bool($manage_repo)

  if $::operatingsystem == 'debian' and $::operatingsystemrelease =~ /^6.*/ {
    fail('We do not work on Debian 6. Please remove this class from your node configuration.')
  }

  # Check if manage_repo is true.
  if $manage_repo {
    include zabbix::repo
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

  # Controlling the 'zabbix-java-gateway' service
  service { 'zabbix-java-gateway':
    ensure     => running,
    enable     => present,
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