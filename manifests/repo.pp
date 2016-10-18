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
# Author Name:
#   ikben@werner-dijkerman.nl
#   Tim Meusel <tim@bastelfreak.de>
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::repo (
  $manage_repo    = $zabbix::params::manage_repo,
  $repo_location  = $zabbix::params::repo_location,
  $zabbix_version = $zabbix::params::zabbix_version,
) inherits zabbix::params {
  if ($manage_repo) {
    case $::operatingsystem {
      'PSBM'        : {
        $majorrelease = '6'
        $reponame     = $majorrelease
      }
      'Amazon'        : {
        $majorrelease = '6'
        $reponame     = $majorrelease
      }
      'oraclelinux' : {
        $majorrelease = $::operatingsystemmajrelease
        $reponame     = $majorrelease
      }
      default       : {
        $majorrelease = $::operatingsystemmajrelease
        $reponame     = $::operatingsystemmajrelease
      }
    }

    case $::osfamily {
      'RedHat' : {
        # Zabbix-3.2 and newer RPMs are signed with the GPG key
        if versioncmp($zabbix_version, '3.2') < 0 {
          $gpgkey = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
        }
        else {
          $gpgkey = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591'
        }

        yumrepo { 'zabbix':
          name     => "Zabbix_${reponame}_${::architecture}",
          descr    => "Zabbix_${reponame}_${::architecture}",
          baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${majorrelease}/\$basearch/",
          gpgcheck => '1',
          gpgkey   => $gpgkey,
          priority => '1',
        }

        yumrepo { 'zabbix-nonsupported':
          name     => "Zabbix_nonsupported_${reponame}_${::architecture}",
          descr    => "Zabbix_nonsupported_${reponame}_${::architecture}",
          baseurl  => "http://repo.zabbix.com/non-supported/rhel/${majorrelease}/\$basearch/",
          gpgcheck => '1',
          gpgkey   => $gpgkey,
          priority => '1',
        }

      }
      'Debian' : {
        include ::apt
        if ($::architecture == 'armv6l') {
          apt::source { 'zabbix':
            location => 'http://naizvoru.com/raspbian/zabbix',
            repos    => 'main',
            key      => {
              'id'     => 'BC274A7EA7FD5DD267C9A18FD54A213C80E871A7',
              'source' => 'http://naizvoru.com/raspbian/zabbix/conf/boris@steki.net.gpg.key',
            }
            ,
            include  => {
              'src' => false,
            }
            ,
          }
        } else {
          $operatingsystem = downcase($::operatingsystem)
          case $::operatingsystemrelease {
            /\/sid$/ : { $releasename = regsubst($::operatingsystemrelease, '/sid$', '') }
            default  : { $releasename = $::lsbdistcodename }
          }
          apt::source { 'zabbix':
            location => "http://repo.zabbix.com/zabbix/${zabbix_version}/${operatingsystem}/",
            repos    => 'main',
            release  => $releasename,
            key      => {
              'id'     => 'FBABD5FB20255ECAB22EE194D13D58E479EA5ED4',
              'source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
            }
            ,
          }
        }
        Apt::Source['zabbix'] -> Package<|tag == 'zabbix'|>
        Class['Apt::Update']  -> Package<|tag == 'zabbix'|>
      }
      default  : {
        fail("Managing a repo on ${::osfamily} is currently not implemented")
      }
    }
  } # end if ($manage_repo)
}
