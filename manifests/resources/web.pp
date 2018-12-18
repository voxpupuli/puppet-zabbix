# == Class zabbix::resources::server
#
# This will load all zabbix related items from
# the puppet database and uses the zabbixapi
# gem to add/configure hosts via the zabbix-api
#
# === Requirements
#
# Nothing.
#
# When manage_resource is set to true, this class
# will be loaded from 'zabbix::server'. So no need
# for loading this class manually.
#
class zabbix::resources::web (
  String[1] $zabbix_url,
  String[1] $zabbix_user,
  String[1] $zabbix_pass,
  Boolean   $apache_use_ssl,
) {
  file { '/etc/zabbix/api.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('zabbix/api.conf.epp', {
      zabbix_url     => $zabbix_url,
      zabbix_user    => $zabbix_user,
      zabbix_pass    => $zabbix_pass,
      apache_use_ssl => $apache_use_ssl,
    }),
  }

  Zabbix_proxy <<| |>> {
    require        => [
      Service['zabbix-server'],
      Package['zabbixapi'],
      File['/etc/zabbix/api.conf'],
    ],
  }
  -> Zabbix_template <<| |>>
  -> Zabbix_host <<| |>>
  -> Zabbix_userparameters <<| |>>
}
