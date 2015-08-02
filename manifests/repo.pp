# == Class: zabbix::repo
#
#  If enabled, this will install the repository used for installing zabbix
#
#  Please note:
#  This class will be called from zabbix::server, zabbix::proxy and
#  zabbix::agent. No need for calling this class manually.
#
# === Parameters
#
# [*manage_repo*]
#   When true, it will create repository for installing the server.
#
# [*zabbix_version*]
#   This is the zabbix version.
#
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
  $manage_repo    = $zabbix::params::manage_repo,
  $zabbix_version = $zabbix::params::zabbix_version,
) inherits zabbix::params {

  if ($manage_repo) {
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
      /^8.*/: {
        $majorrelease = '8'
        $debian       = 'jessie'
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
      # Debian unstable releases look something like "jessie/sid"
      # In this case, just use the first bit as the version
      /\/sid$/: {
        # Zabbix repo doesn't yet support jessie, use wheezy instead
        if ($::operatingsystemrelease == 'jessie/sid') {
          $debian = 'wheezy'
        } else {
          $debian = regsubst($::operatingsystemrelease, '/sid$', '')
        }
      }
      # Amazon Linux using epel 6
      /^20??.??/: {
        $majorrelease = '6'
      }
      default: {
        fail("This is an unsupported operating system (${::operatingsystem} ${::operatingsystemrelease})")
      }
    }

    case $::operatingsystem {
      'centos','scientific','redhat','oraclelinux','amazon' : {
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
        if ($::architecture == 'armv6l') {
          apt::source { 'zabbix':
            location => 'http://naizvoru.com/raspbian/zabbix',
            release  => $debian,
            repos    => 'main',
            key      => {
              'id'     => 'BC274A7EA7FD5DD267C9A18FD54A213C80E871A7',
              'source' => 'http://naizvoru.com/raspbian/zabbix/conf/boris@steki.net.gpg.key'
            },
            include  => {
              'src' => false,
            }
          }
        } else {
          apt::source { 'zabbix':
            location => "http://repo.zabbix.com/zabbix/${zabbix_version}/debian/",
            release  => $debian,
            repos    => 'main',
            key      => {
              'id'     => 'FBABD5FB20255ECAB22EE194D13D58E479EA5ED4',
              'source' => 'http://repo.zabbix.com/zabbix-official-repo.key'
            },
          }
        }
      } # END 'debian'
      'ubuntu' : {
        apt::source { 'zabbix':
          location => "http://repo.zabbix.com/zabbix/${zabbix_version}/ubuntu/",
          release  => $ubuntu,
          repos    => 'main',
          key      => {
            'id'     => 'FBABD5FB20255ECAB22EE194D13D58E479EA5ED4',
            'source' => 'http://repo.zabbix.com/zabbix-official-repo.key'
          },
        }
      } # END 'ubuntu'
      default : {
        fail('Unrecognized operating system for webserver')
      }
    }
  } # end if ($manage_repo)
}
