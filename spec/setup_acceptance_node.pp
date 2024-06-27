case $facts['os']['name'] {
  'Debian': {
    # On Debian it seems that make is searching for mkdir in /usr/bin/ but mkdir
    # does not exist. Symlink it from /bin/mkdir to make it work.
    if $facts['os']['release']['major'] < '12' {
      file { '/usr/bin/mkdir':
        ensure => link,
        target => '/bin/mkdir',
      }
    }
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
