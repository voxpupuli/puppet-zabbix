# == Define: zabbix::userparameters
#
#  This will install an userparameters file with keys for item that can be check
#  with zabbix.
#
# === Requirements
#
# === Parameters
#
# [*source*]
#   Module to load at server startup.
#
# [*content*]
#   Module to load at server startup.
#
# === Example
#
#  zabbix::userparameters { 'mysql.conf':
#    source => 'puppet:///modules/zabbix/mysqld.conf',
#  }
#
#  zabbix::userparameters { 'mysql.conf':
#    content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive',
#  }
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
define zabbix::userparameters (
  $source  = '',
  $content = '',
) {
  $include_dir = getvar('zabbix::params::agent_include')

  if $source != '' {
    file { "${include_dir}/${name}.conf":
      ensure  => present,
      owner   => 'zabbix',
      group   => 'zabbix',
      mode    => '0755',
      source  => $source,
    }
  }

  if $content != '' {
    file { "${include_dir}/${name}.conf":
      ensure  => present,
      owner   => 'zabbix',
      group   => 'zabbix',
      mode    => '0755',
      content => $content,
    }
  }
}
