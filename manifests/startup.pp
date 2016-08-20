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
define zabbix::startup {
  if str2bool($::systemd) {
    contain ::systemd
    file { "/etc/systemd/system/${name}.service":
      ensure  => file,
      mode    => '0664',
      content => template("zabbix/${name}-systemd.init.erb"),
    } ~>
    Exec['systemctl-daemon-reload']
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
  }
}
