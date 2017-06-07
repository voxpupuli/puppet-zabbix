# == Define: zabbix::userparameters
#
#  This will install an userparameters file with keys for items that can be checked
#  with zabbix.
#
# === Requirements
#
# === Parameters
#
# [*source*]
#   File which holds several userparameter entries.
#
# [*content*]
#   When you have 1 userparameter entry which you want to install.
#
# [*script*]
#   Low level discovery (LLD) script.
#
# [*script_ext*]
#   The script extention. Should be started with the dot. Like: .sh .bat .py
#
# [*template*]
#   When you use exported resources (when manage_resources is set to true on other components)
#   you'll can add the name of the template which correspondents with the 'content' or
#   'source' which you add. The template will be added to the host.
#
# [*script_dir*]
#   When 'script' is used, this parameter can provide the directly where this script needs to
#   be placed. Default: '/usr/bin'
#
# === Example
#
#  zabbix::userparameters { 'mysql':
#    source => 'puppet:///modules/zabbix/mysqld.conf',
#  }
#
#  zabbix::userparameters { 'mysql':
#    content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive',
#  }
#
#  Or when using exported resources (manage_resources is set to true)
#  zabbix::userparameters { 'mysql':
#    source   => 'puppet:///modules/zabbix/mysqld.conf',
#    template => 'Template App MySQL',
#  }
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
define zabbix::userparameters (
  $source     = '',
  $content    = '',
  $script     = '',
  $script_ext = '',
  $template   = '',
  $script_dir = '/usr/bin',
) {
  $include_dir          = getvar('::zabbix::agent::include_dir')
  $zabbix_package_agent = getvar('::zabbix::agent::zabbix_package_agent')
  $agent_config_owner   = getvar('::zabbix::agent::agent_config_owner')
  $agent_config_group   = getvar('::zabbix::agent::agent_config_group')

  if $source != '' {
    file { "${include_dir}/${name}.conf":
      ensure  => present,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => '0644',
      source  => $source,
      notify  => Service['zabbix-agent'],
      require => Package[$zabbix_package_agent],
    }
  }

  if $content != '' {
    file { "${include_dir}/${name}.conf":
      ensure  => present,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => '0644',
      content => $content,
      notify  => Service['zabbix-agent'],
      require => Package[$zabbix_package_agent],
    }
  }

  if $script != '' {
    file { "${script_dir}/${name}${script_ext}":
      ensure  => present,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => '0755',
      source  => $script,
      notify  => Service['zabbix-agent'],
      require => Package[$zabbix_package_agent],
    }
  }

  # If template is defined, it means we have an template in zabbix
  # which needs to be loaded for this host. When exported resources is
  # used/enabled, we do this automatically.
  if $template != '' {
    zabbix::resources::userparameters { "${::hostname}_${name}":
      hostname => $::fqdn,
      template => $template,
    }
  }
}
