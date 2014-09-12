# == Class: zabbix::backuppc
#
#  This will install backuppc script used to monitor backuppc
#
# === Authors
#
# Author Name: bretif@phosphore.eu
#
# === Copyright
#
# Copyright 2014 Bertrand RETIF
#
class zabbix::backuppc () {
  file { "/etc/zabbix/scripts":
                owner   => "zabbix",
                group   => "zabbix",
                mode    => 0755,
                ensure  => [directory, present],
        }

  file { '/etc/zabbix/scripts/backuppc_info.pl':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    replace => true,
    source  => "puppet:///modules/zabbix/backuppc_info.pl",
    
  }
}