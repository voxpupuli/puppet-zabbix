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
  $manage_apt     = $zabbix::params::manage_apt,
  $repo_location  = $zabbix::params::repo_location,
  $zabbix_version = $zabbix::params::zabbix_version,
) inherits zabbix::params {
  if ($manage_repo) {
    case $facts['os']['name'] {
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

    case $facts['os']['family'] {
      'RedHat' : {
        # Zabbix-3.2 and newer RPMs are signed with the GPG key
        if versioncmp($zabbix_version, '3.2') < 0 {
          $gpgkey_zabbix = 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
          $gpgkey_nonsupported = $gpgkey_zabbix
        }
        else {
          $gpgkey_zabbix = 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591'
          $gpgkey_nonsupported = 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4'
        }

        yumrepo { 'zabbix':
          name     => "Zabbix_${reponame}_${::architecture}",
          descr    => "Zabbix_${reponame}_${::architecture}",
          baseurl  => "https://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${majorrelease}/\$basearch/",
          gpgcheck => '1',
          gpgkey   => $gpgkey_zabbix,
          priority => '1',
        }

        yumrepo { 'zabbix-nonsupported':
          name     => "Zabbix_nonsupported_${reponame}_${::architecture}",
          descr    => "Zabbix_nonsupported_${reponame}_${::architecture}",
          baseurl  => "https://repo.zabbix.com/non-supported/rhel/${majorrelease}/\$basearch/",
          gpgcheck => '1',
          gpgkey   => $gpgkey_nonsupported,
          priority => '1',
        }

      }
      'Debian' : {
        if ($manage_apt) {
          # We would like to provide the repos with https urls instead of http
          # this requires the apt-transport-https package, but we don't want to manage
          # that package here. That should be handled in a profile :(
          # somebody should implement https here but make it optional
          include ::apt
        }

        if ($::architecture == 'armv6l') {
          apt::source { 'zabbix':
            location => 'http://naizvoru.com/raspbian/zabbix',
            repos    => 'main',
            key      => {
              'id'     => 'BC274A7EA7FD5DD267C9A18FD54A213C80E871A7',
              'source' => 'https://naizvoru.com/raspbian/zabbix/conf/boris@steki.net.gpg.key',
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
              'source' => 'https://repo.zabbix.com/zabbix-official-repo.key',
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
