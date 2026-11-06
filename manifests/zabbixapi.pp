# @summary This will install the zabbixapi gem.
#
# @param zabbix_version This is the zabbix version.
# @param puppetgem Provider for the zabbixapi gem package.
class zabbix::zabbixapi (
  $zabbix_version = $zabbix::params::zabbix_version,
  $puppetgem      = $zabbix::params::puppetgem,
) inherits zabbix::params {
  # Determine correct zabbixapi version.
  case $zabbix_version {
    /^[56]\.[024]/: {
      $zabbixapi_version = '5.0.0-alpha1'
      if versioncmp($facts['ruby']['version'] , '3') < 0 {
        package { 'public_suffix':
          ensure   => '5.1.1',
          provider => $puppetgem,
        }
        Package['public_suffix'] -> Package['zabbixapi']
      }
    }
    default: {
      fail("Zabbix ${zabbix_version} is not supported!")
    }
  }

  $compile_packages = $facts['os']['family'] ? {
    'RedHat' => ['make', 'gcc-c++', 'rubygems', 'ruby'],
    'Debian' => ['make', 'g++', 'ruby-dev', 'ruby', 'pkg-config',],
    default  => [],
  }
  ensure_packages($compile_packages)

  # Installing the zabbixapi gem package. We need this gem for
  # communicating with the zabbix-api. This is way better then
  # doing it ourself.
  package { 'zabbixapi':
    ensure   => $zabbixapi_version,
    provider => $puppetgem,
  }
}
