case $facts['os']['name'] {
  'Ubuntu': {
    # The Ubuntu 18.04+ docker image has a dpkg config that won't install docs, to keep used space low
    # zabbix packages their SQL file as doc, we need that for bootstrapping the database
    file { '/etc/dpkg/dpkg.cfg.d/excludes':
      ensure => absent,
    }
  }
  default: {}
}

case $facts['os']['family'] {
  'RedHat': {
    if $facts['os']['release']['major'] == '7' {
      # The CentOS docker image has a yum config that won't install docs, to keep used space low
      # zabbix packages their SQL file as doc, we need that for bootstrapping the database
      augeas { 'remove tsflags=nodocs from yum.conf':
        changes => [
          'rm /files/etc/yum.conf/main/tsflags',
        ],
      }
    }
  }
  default: {}
}
