# == Define: zabbix::startup
#
#  This manage the zabbix related service startup script.
#
# === Requirements
#
# === Parameters
#
# === Example
#
#  zabbix::startup { 'agent':
#  }
#
define zabbix::startup (
  Optional[Stdlib::Absolutepath] $pidfile                = undef,
  Optional[Stdlib::Absolutepath] $agent_configfile_path  = undef,
  Optional[Stdlib::Absolutepath] $server_configfile_path = undef,
  Optional[String] $database_type                        = undef,
  Optional[String] $zabbix_user                          = undef,
  String $additional_service_params                      = '',
  ) {

  case $title {
    /agent/: {
      unless $agent_configfile_path {
        fail('you have to provide a agent_configfile_path param')
      }
    }
    /server/: {
      unless $server_configfile_path {
        fail('you have to provide a server_configfile_path param')
      }
      unless $database_type {
        fail('you have to provide a database_type param')
      }
    }
    default: {
      fail('we currently only spport a title that contains agent or server')
    }
  }
  # provided by camp2camp/systemd
  if $facts['systemd'] {
    contain ::systemd
    file { "/etc/systemd/system/${name}.service":
      ensure  => file,
      mode    => '0664',
      content => template("zabbix/${name}-systemd.init.erb"),
    }
    ~> Exec['systemctl-daemon-reload']
    file { "/etc/init.d/${name}":
      ensure  => absent,
    }
  } elsif $::osfamily in ['Debian', 'RedHat'] {
    # Currently other osfamily without systemd is not supported
    $osfamily_downcase = downcase($::osfamily)
    file { "/etc/init.d/${name}":
      ensure  => file,
      mode    => '0755',
      content => template("zabbix/${name}-${osfamily_downcase}.init.erb"),
    }
  } else {
    fail('We currently only support Debian and RedHat osfamily as non-systemd')
  }
}
