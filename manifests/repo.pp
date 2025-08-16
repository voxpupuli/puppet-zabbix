# @summary If enabled, this will install the repository used for installing zabbix
# @param manage_repo When true, it will create repository for installing the server.
# @param manage_apt Whether the module should manage apt repositories for Debian based systems.
# @param zabbix_version This is the zabbix version.
# @param repo_location A custom repo location (e.g. your own mirror)
# @param repo_gpg_key_location 
#   A custom repo GPG key location (e.g. an airlocked copy of the gpg key)
# @param frontend_repo_location A custom repo location for frontend package.
# @param unsupported_repo_location
#   A custom repo location for unsupported content (e.g. your own mirror)
#   Currently only supported under RedHat based systems.
# @param unsupported_repo_gpg_key_location
#   A custom repo GPG key location (e.g. an airlocked copy of the gpg key)
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
# @author Tim Meusel <tim@bastelfreak.de>
class zabbix::repo (
  Boolean                   $manage_repo                       = $zabbix::params::manage_repo,
  Boolean                   $manage_apt                        = $zabbix::params::manage_apt,
  Optional[Stdlib::HTTPUrl] $repo_location                     = $zabbix::params::repo_location,
  Optional[Stdlib::HTTPUrl] $repo_gpg_key_location             = $zabbix::params::repo_gpg_key_location,
  Optional[Stdlib::HTTPUrl] $frontend_repo_location            = $zabbix::params::frontend_repo_location,
  Optional[Stdlib::HTTPUrl] $unsupported_repo_location         = $zabbix::params::unsupported_repo_location,
  Optional[Stdlib::HTTPUrl] $unsupported_repo_gpg_key_location = $zabbix::params::unsupported_repo_gpg_key_location,
  String[1]                 $zabbix_version                    = $zabbix::params::zabbix_version,
) inherits zabbix::params {
  if $manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        $majorrelease = $facts['os']['release']['major']
        if versioncmp($zabbix_version, '7.0') >= 0 {
          $_gpgkey_zabbix = $repo_gpg_key_location ? {
            undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005',
            default => "${repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-B5333005",
          }
          if versioncmp(fact('os.release.major'), '9') >= 0 {
            $_gpgkey_nonsupported = $unsupported_repo_gpg_key_location ? {
              undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD',
              default => "${unsupported_repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-08EFA7DD",
            }
          } else {
            $_gpgkey_nonsupported = $unsupported_repo_gpg_key_location ? {
              undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005',
              default => "${unsupported_repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-B5333005",
            }
          }
        } elsif versioncmp(fact('os.release.major'), '9') >= 0 {
          $_gpgkey_zabbix = $repo_gpg_key_location ? {
            undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD',
            default => "${repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-08EFA7DD",
          }
          $_gpgkey_nonsupported = $unsupported_repo_gpg_key_location ? {
            undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD',
            default => "${unsupported_repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-08EFA7DD",
          }
        } else {
          $_gpgkey_zabbix = $repo_gpg_key_location ? {
            undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591',
            default => "${repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-A14FE591",
          }
          $_gpgkey_nonsupported = $unsupported_repo_gpg_key_location ? {
            undef   => 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4',
            default => "${unsupported_repo_gpg_key_location}/RPM-GPG-KEY-ZABBIX-79EA5ED4",
          }
        }

        $_repo_location = $repo_location ? {
          undef   => versioncmp($zabbix_version, '7.2') ? {
            # Version older than 7.2
            -1      => "https://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${majorrelease}/\$basearch/",
            # Version 7.2 and newer
            default => "https://repo.zabbix.com/zabbix/${zabbix_version}/stable/rhel/${majorrelease}/\$basearch/",
          },
          default => $repo_location,
        }

        yumrepo { 'zabbix':
          name     => "Zabbix_${majorrelease}_${facts['os']['architecture']}",
          descr    => "Zabbix_${majorrelease}_${facts['os']['architecture']}",
          baseurl  => $_repo_location,
          gpgcheck => '1',
          gpgkey   => $_gpgkey_zabbix,
          priority => '1',
        }

        $_unsupported_repo_location = $unsupported_repo_location ? {
          undef   => "https://repo.zabbix.com/non-supported/rhel/${majorrelease}/\$basearch/",
          default => $unsupported_repo_location,
        }

        yumrepo { 'zabbix-nonsupported':
          name     => "Zabbix_nonsupported_${majorrelease}_${facts['os']['architecture']}",
          descr    => "Zabbix_nonsupported_${majorrelease}_${facts['os']['architecture']}",
          baseurl  => $_unsupported_repo_location,
          gpgcheck => '1',
          gpgkey   => $_gpgkey_nonsupported,
          priority => '1',
        }
      }
      'Debian': {
        if ($manage_apt) {
          # We would like to provide the repos with https urls instead of http
          # this requires the apt-transport-https package, but we don't want to manage
          # that package here. That should be handled in a profile :(
          # somebody should implement https here but make it optional
          include apt
        }

        if ($facts['os']['distro']['id'] == 'Raspbian') {
          $operatingsystem = 'raspbian'
        } elsif ($facts['os']['architecture'] in ['arm64', 'aarch64']) {
          # arm64 is the Debian name, but some facter versions report aarch64 instead
          $operatingsystem = "${downcase($facts['os']['name'])}-arm64"
        } else {
          $operatingsystem = downcase($facts['os']['name'])
        }
        case $facts['os']['release']['full'] {
          /\/sid$/: { $releasename = regsubst($facts['os']['release']['full'], '/sid$', '') }
          default: { $releasename = $facts['os']['distro']['codename'] }
        }

        $_repo_location = $repo_location ? {
          undef   => versioncmp($zabbix_version, '7.2') ? {
            # Version older than 7.2
            -1      => "http://repo.zabbix.com/zabbix/${zabbix_version}/${operatingsystem}/",
            # Version 7.2 and newer
            default => "http://repo.zabbix.com/zabbix/${zabbix_version}/stable/${operatingsystem}/",
          },
          default => $repo_location,
        }

        $_gpgkey_zabbix = $repo_gpg_key_location ? {
          undef   => 'https://repo.zabbix.com/zabbix-official-repo.key',
          default => "${repo_gpg_key_location}/zabbix-official-repo.key",
        }

        apt::key { 'zabbix-FBABD5F':
          id     => 'FBABD5FB20255ECAB22EE194D13D58E479EA5ED4',
          source => $_gpgkey_zabbix,
        }
        apt::key { 'zabbix-A1848F5':
          id     => 'A1848F5352D022B9471D83D0082AB56BA14FE591',
          source => $_gpgkey_zabbix,
        }
        apt::key { 'zabbix-4C3D6F2':
          id     => '4C3D6F2CC75F5146754FC374D913219AB5333005',
          source => $_gpgkey_zabbix,
        }

        # Debian 11 provides Zabbix 5.0 by default. This can cause problems for 4.0 versions
        $pinpriority = $facts['os']['release']['major'] ? {
          '11'    => 1000,
          default => undef,
        }
        apt::source { 'zabbix':
          location => $_repo_location,
          repos    => 'main',
          release  => $releasename,
          pin      => $pinpriority,
          require  => [
            Apt_key['zabbix-FBABD5F'],
            Apt_key['zabbix-A1848F5'],
            Apt_key['zabbix-4C3D6F2'],
          ],
        }

        Apt::Source['zabbix'] -> Package<|tag == 'zabbix'|>
        Class['Apt::Update'] -> Package<|tag == 'zabbix'|>
      }
      default: {
        fail("Managing a repo on ${facts['os']['family']} is currently not implemented")
      }
    }
  } # end if ($manage_repo)
}
