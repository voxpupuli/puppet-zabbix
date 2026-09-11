case $facts['os']['name'] {
  'Debian': {
    package { 'gnupg':
      ensure => present,
    }
  }
  'Ubuntu': {
    # The Ubuntu 18.04+ docker image has a dpkg config that won't install docs, to keep used space low
    # zabbix packages their SQL file as doc, we need that for bootstrapping the database
    file { '/etc/dpkg/dpkg.cfg.d/excludes':
      ensure => absent,
    }
  }
  default: {}
}
