# == Define: zabbix::userparameters
#
#  This will install an userparameters file with keys for items that can be checked
#  with zabbix.
#
# === Requirements
#
# === Parameters
#
# [*ensure*]
#   If the userparameter should be `present` or `absent`
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
# [*config_mode*]
#   When 'config_mode' is used, this parameter can provide the mode of the config file who will be created
#   to keep some credidentials private. Default: '0644'
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
  Enum['present', 'absent']    $ensure      = 'present',
  Optional[Stdlib::Filesource] $source      = undef,
  Optional[String[1]]          $content     = undef,
  Optional[Stdlib::Filesource] $script      = undef,
  Optional[String[1]]          $script_ext  = undef,
  Optional[String[1]]          $template    = undef,
  Stdlib::Absolutepath         $script_dir  = '/usr/bin',
  Stdlib::Filemode             $config_mode = '0644',
) {
  include zabbix::agent
  $include_dir          = $zabbix::agent::include_dir
  $zabbix_package_agent = $zabbix::agent::zabbix_package_agent
  $agent_config_owner   = $zabbix::agent::agent_config_owner
  $agent_config_group   = $zabbix::agent::agent_config_group
  $agent_servicename    = $zabbix::agent::servicename

  if $source {
    file { "${include_dir}/${name}.conf":
      ensure  => $ensure,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => $config_mode,
      source  => $source,
      notify  => Service[$agent_servicename],
      require => Package[$zabbix_package_agent],
    }
  }

  if $content {
    file { "${include_dir}/${name}.conf":
      ensure  => $ensure,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => $config_mode,
      content => $content,
      notify  => Service[$agent_servicename],
      require => Package[$zabbix_package_agent],
    }
  }

  if $script {
    file { "${script_dir}/${name}${script_ext}":
      ensure  => $ensure,
      owner   => $agent_config_owner,
      group   => $agent_config_group,
      mode    => '0755',
      source  => $script,
      notify  => Service[$agent_servicename],
      require => Package[$zabbix_package_agent],
    }
  }

  # If template is defined, it means we have an template in zabbix
  # which needs to be loaded for this host. When exported resources is
  # used/enabled, we do this automatically.
  if $template {
    zabbix::resources::userparameters { "${facts['networking']['hostname']}_${name}":
      ensure   => $ensure,
      hostname => $facts['networking']['fqdn'],
      template => $template,
    }
  }
}
