# Needed for os.distro.codebase fact on ubuntu 16/18 on puppet 6
if $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['puppetversion'], '7.0.0') < 0 {
  package{'lsb-release':
    ensure => present,
  }
}
