# @summary This will install and configure the zabbix-agent deamon
# @param zabbix_version This is the zabbix version.
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param manage_firewall When true, it will create iptables rules.
# @param manage_repo When true, it will create repository for installing the javagateway.
# @param pidfile Name of pid file.
# @param listenip List of comma delimited ip addresses that the agent should listen on.
# @param listenport Agent will listen on this port for connections from the server.
# @param startpollers Number of worker threads to start.
# @param timeout Number of worker threads to start.
# @example
#  class { 'zabbix::javagateway':
#    zabbix_version => '5.2',
#  }
# @author Werner Dijkerman ikben@werner-dijkerman.nl
class zabbix::javagateway (
  $zabbix_version           = $zabbix::params::zabbix_version,
  $zabbix_package_state     = $zabbix::params::zabbix_package_state,
  Boolean $manage_firewall  = $zabbix::params::manage_firewall,
  Boolean $manage_repo      = $zabbix::params::manage_repo,
  $pidfile                  = $zabbix::params::javagateway_pidfile,
  $listenip                 = $zabbix::params::javagateway_listenip,
  $listenport               = $zabbix::params::javagateway_listenport,
  $startpollers             = $zabbix::params::javagateway_startpollers,
  $timeout                  = $zabbix::params::javagateway_timeout,
) inherits zabbix::params {
  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
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
    ensure  => file,
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
    enable     => true,
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
