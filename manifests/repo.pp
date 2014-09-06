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
  $zabbix_version
) {

  # Figuring out which major release we have. Or which release name
  # for debian/ununtu releases.
  case $::operatingsystemrelease {
    /^14.04/: {
      $majorrelease = '14'
      $ubuntu       = 'trusty'
    }
    /^12.04/: {
      $majorrelease = '12'
      $ubuntu       = 'precise'
    }
    /^10.04/: {
      $majorrelease = '10'
      $ubuntu       = 'lucid'
    }
    /^7.*/: {
      $majorrelease = '7'
      $debian       = 'wheezy'
    }
    /^6.*/: {
      $majorrelease = '6'
      $debian       = 'squeeze'
    }
    /^5.*/: {
      $majorrelease = '5'
      $debian       = 'lenny'
    }
  }

  case $::operatingsystem {
    'centos','scientific','redhat','oraclelinux' : {
      yumrepo { 'zabbix':
        name     => "Zabbix_${majorrelease}_${::architecture}",
        descr    => "Zabbix_${majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${majorrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }
      yumrepo { 'zabbix-nonsupported':
        name     => "Zabbix_nonsupported_${majorrelease}_${::architecture}",
        descr    => "Zabbix_nonsupported_${majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/non-supported/rhel/${majorrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }

    } # END 'centos','redhat','oraclelinux'
    'XenServer' : {
      yumrepo { 'zabbix':
        name     => "Zabbix_${majorrelease}_${::architecture}",
        descr    => "Zabbix_${majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/5/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }
      yumrepo { 'zabbix-nonsupported':
        name     => "Zabbix_nonsupported_${majorrelease}_${::architecture}",
        descr    => "Zabbix_nonsupported_${majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/non-supported/rhel/5/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }

    } # END 'XenServer'
    'debian' : {
      apt::source { 'zabbix':
        location   => "http://repo.zabbix.com/zabbix/${zabbix_version}/debian/",
        release    => $debian,
        repos      => 'main',
        key        => '79EA5ED4',
        key_source => 'http://repo.zabbix.com/zabbix-official-repo.key',
      }
    } # END 'debian'
    'ubuntu' : {
      apt::source { 'zabbix':
        location   => "http://repo.zabbix.com/zabbix/${zabbix_version}/ubuntu/",
        release    => $ubuntu,
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
