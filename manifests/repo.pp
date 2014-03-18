# Class: zabbix::repo
#
# This class installed the Zabbix Repository
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
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
