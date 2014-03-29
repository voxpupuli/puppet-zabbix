# == Class: zabbix::repo
#
#  This will install the yum repository used for installing zabbix
#
#  Please note:
#  This class will be called from zabbix::server, zabbix::proxy and
#  zabbix::agent. No need for calling this class manually.
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::repo(
  $zabbix_version = $zabbix::params::zabbix_version
) inherits zabbix::params {
  case $::operatingsystem {
    'centos','redhat' : {
      $os  = 'rhel'
      $gpg = 'RPM-GPG-KEY-ZABBIX'
    }
    'debian' : {
      $os = 'debian'
      $gpg = 'zabbix-official-repo.key'
    }
    'ubuntu' : {
      $os = 'ubuntu'
      $gpg = 'zabbix-official-repo.key'
    }
    default : {
      fail('Unrecognized operating system for webserver')
    }
  }

  yumrepo { 'zabbix':
    name     => "Zabbix_${::operatingsystemmajrelease}_${::architecture}",
    baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/${os}/${::operatingsystemmajrelease}/${::architecture}/",
    gpgcheck => '1',
    gpgkey   => "http://repo.zabbix.com/${gpg}",
    priority => '1',
  }
}
