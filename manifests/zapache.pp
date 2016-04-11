# == Class: zabbix::zapache
#
#  This will install and configure the zapache monitoring script
#  Upstream: https://github.com/lorf/zapache
#
# === Requirements
#
# Must import zapache-template.xml and zapache-template-active.xml
# Using the Zabbix web portal
# Note: I believe this can be automated via the API but have not done s.
#
# Must bind "Template App Apache Web Server zapache" OR "Template App Apache Web Server zapache Agent Active"
# to the node.
#
# manage_resources must be true.
#
# Otherwise, no requirements
#
# === Parameters
#
# [*apache_status*]
#   Boolean. False by default. Installs zapache monitoring script when true.
#
# === Example
#
#  Basic installation:
#  class { 'zabbix::agent':
#    manage_resources => true,
#    apache_status    => true,
#    zbx_templates    => [ 'Template App Apache Web Server zapache'],
#  }
#
#
# === Authors
#
# Author Name: rob@roberttisdale.com
#
# === Copyright
#
# The MIT License (MIT)
# Copyright (c) [2015] [Robert Tisdale]
#


# Check if apache_status is true, installs Zapache scripts. Defaults to false.
class zabbix::zapache (
  $apache_status         = $zabbix::params::apache_status,
  ) inherits zabbix::params {
  # Check if apache_status is boolean
  validate_bool($apache_status)

  if $apache_status {
    file { [ '/var/lib/zabbixsrv/','/var/lib/zabbixsrv/externalscripts/']:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/var/lib/zabbixsrv/externalscripts/zapache':
      ensure => present,
      source => 'puppet:///modules/zabbix/zapache/zapache',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/etc/zabbix/zabbix_agentd.d/userparameter_zapache.conf':
      ensure  => present,
      source  => 'puppet:///modules/zabbix/zapache/userparameter_zapache.conf.sample',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['zabbix-agent'],
      notify  => Service['zabbix-agent'],
    }
    file { '/etc/httpd/conf.d/httpd-server-status.conf':
      ensure  => present,
      source  => 'puppet:///modules/zabbix/zapache/httpd-server-status.conf.sample',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [ Package['zabbix-agent'],Package['httpd'] ],
      notify  => Service['httpd'],
    }
  }
}
