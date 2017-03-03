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
# [*zabbix_package_state*]
#   The state of the package that needs to be installed: present or latest.
#   Default: present
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
# [*timeout*]
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
  $zabbix_version           = $zabbix::params::zabbix_version,
  $zabbix_package_state     = $zabbix::params::zabbix_package_state,
  Boolean $manage_firewall  = $zabbix::params::manage_firewall,
  Boolean $manage_repo      = $zabbix::params::manage_repo,
  $pidfile                  = $zabbix::params::javagateway_pidfile,
  $listenip                 = $zabbix::params::javagateway_listenip,
  $listenport               = $zabbix::params::javagateway_listenport,
  $startpollers             = $zabbix::params::javagateway_startpollers,
  $timeout                  = $zabbix::params::javagateway_timeout,
) inherits zabbix::params  {

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { '::zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
  }

  # Installing the package
  package { 'zabbix-java-gateway':
    ensure  => $zabbix_package_state,
    require => Class['zabbix::repo'],
    tag     => 'zabbix',
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
