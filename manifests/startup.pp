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
  Optional[Zabbix::Databases] $database_type             = undef,
  Optional[String] $zabbix_user                          = undef,
  String $additional_service_params                      = '',
  String $service_type                                   = 'simple',
  Optional[Boolean] $manage_database                     = undef,
  Optional[String] $service_name                         = $name,

  ) {

  case downcase($title) {
    /agent/: {
      assert_type(Stdlib::Absolutepath, $agent_configfile_path)
    }
    /server/: {
      assert_type(Stdlib::Absolutepath, $server_configfile_path)
      assert_type(Zabbix::Databases, $database_type)
      assert_type(Boolean, $manage_database)
    }
    default: {
      fail('we currently only spport a title that contains agent or server')
    }
  }
  # provided by camp2camp/systemd
  if $facts['systemd'] {
    contain systemd
    file { "/etc/systemd/system/${name}.service":
      ensure  => file,
      mode    => '0664',
      content => template("zabbix/${service_name}-systemd.init.erb"),
    }
    ~> Exec['systemctl-daemon-reload']
    file { "/etc/init.d/${name}":
      ensure  => absent,
    }
  } elsif $facts['os']['family'] in ['Debian', 'RedHat'] {
    # Currently other osfamily without systemd is not supported
    $osfamily_downcase = downcase($facts['os']['family'])
    file { "/etc/init.d/${service_name}":
      ensure  => file,
      mode    => '0755',
      content => template("zabbix/${name}-${osfamily_downcase}.init.erb"),
    }
  } elsif ($facts['os']['family'] == 'windows') {
    exec { "install_agent_${name}":
      command  => "& 'C:\\Program Files\\Zabbix Agent\\zabbix_agentd.exe' --config ${agent_configfile_path} --install --multiple-agents",
      onlyif   => "if (Get-WmiObject -Class Win32_Service -Filter \"Name='${name}'\"){exit 1}",
      provider => powershell,
      notify   => Service[$name],
    }
  }else {
    fail('We currently only support Debian and RedHat osfamily as non-systemd')
  }
}
