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
    'centos','redhat','oraclelinux' : {
      yumrepo { 'zabbix':
        name     => "Zabbix_${::operatingsystemmajrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${::operatingsystemmajrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => "http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX",
        priority => '1',
      }
    } # END 'centos','redhat','oraclelinux'
    'debian' : {
      apt::source { 'zabbix':
        location   => "http://repo.zabbix.com/zabbix/${zabbix_version}/debian/",
        release    => 'wheezy',
        repos      => 'main',
        key        => '79EA5ED4',
        key_source => 'http://repo.zabbix.com/zabbix-official-repo.key',
      }
    } # END 'debian'
    'ubuntu' : {
      apt::source { 'zabbix':
        location   => "http://repo.zabbix.com/zabbix/${zabbix_version}/ubuntu/",
        release    => 'precise',
        repos      => 'main',
        key        => '79EA5ED4',
        key_source => 'http://repo.zabbix.com/zabbix-official-repo.key',
      }
    } # END 'ubuntu'
    default : {
      fail('Unrecognized operating system for webserver')
    }
  }
}
