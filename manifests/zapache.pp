# @summary This will install and configure the zapache monitoring script Upstream: https://github.com/lorf/zapache
# @param apache_status Boolean. False by default. Installs zapache monitoring script when true.
# @example Basic installation:
#  class { 'zabbix::agent':
#    manage_resources => true,
#    apache_status    => true,
#    zbx_templates    => [ 'Template App Apache Web Server zapache'],
#  }
# @author Robert Tisdale <rob@roberttisdale.com>
class zabbix::zapache (
  Boolean $apache_status = $zabbix::params::apache_status,
) inherits zabbix::params {
  if $apache_status {
    file { ['/var/lib/zabbixsrv/','/var/lib/zabbixsrv/externalscripts/']:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/var/lib/zabbixsrv/externalscripts/zapache':
      ensure => file,
      source => 'puppet:///modules/zabbix/zapache/zapache',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/etc/zabbix/zabbix_agentd.d/userparameter_zapache.conf':
      ensure  => file,
      source  => 'puppet:///modules/zabbix/zapache/userparameter_zapache.conf.sample',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['zabbix-agent'],
      notify  => Service['zabbix-agent'],
    }
    file { '/etc/httpd/conf.d/httpd-server-status.conf':
      ensure  => file,
      source  => 'puppet:///modules/zabbix/zapache/httpd-server-status.conf.sample',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [Package['zabbix-agent'],Package['httpd']],
      notify  => Service['httpd'],
    }
  }
}
