# == Class zabbix::sender
#
#  This will install and configure the zabbix-agent deamon
#
# === Requirements
#
#   No special requirements
#
# === Parameters
#
# [*zabbix_version*]
#   This is the zabbix version.
#
# [*zabbix_package_state*]
#   The state of the package that needs to be installed: present or latest.
#   Default: present
#
# [*manage_repo*]
#   When true, it will create repository for installing the agent.
#
class zabbix::sender(
  $zabbix_version        = $zabbix::params::zabbix_version,
  $zabbix_package_state  = $zabbix::params::zabbix_package_state,
  $manage_repo           = $zabbix::params::manage_repo,
) inherits zabbix::params {

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { '::zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
  }

  # Installing the package
  package { 'zabbix-sender':
    ensure  => $zabbix_package_state,
    require => Class['zabbix::repo'],
    tag     => 'zabbix',
  }
}
