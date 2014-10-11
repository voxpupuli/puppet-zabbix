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
class zabbix::resources::server (
  $zabbix_url,
  $zabbix_user,
  $zabbix_pass,
  $apache_use_ssl,
) {

  Zabbix_proxy <<| |>> {
    zabbix_url     => $zabbix_url,
    zabbix_user    => $zabbix_user,
    zabbix_pass    => $zabbix_pass,
    apache_use_ssl => $apache_use_ssl,
    require        => [
      Service['zabbix-server'],
      Package['zabbixapi'],
    ],
  } ->
  Zabbix_host <<| |>> {
    zabbix_url     => $zabbix_url,
    zabbix_user    => $zabbix_user,
    zabbix_pass    => $zabbix_pass,
    apache_use_ssl => $apache_use_ssl,
  } ->
  Zabbix_userparameters <<| |>> {
    zabbix_url     => $zabbix_url,
    zabbix_user    => $zabbix_user,
    zabbix_pass    => $zabbix_pass,
    apache_use_ssl => $apache_use_ssl,
  }
}
