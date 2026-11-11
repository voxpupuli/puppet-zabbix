# @summary This will load all zabbix related items from the puppet database and uses the zabbixapi gem to add/configure hosts via the zabbix-api
# @param zabbix_url Url on which zabbix is available.
# @param zabbix_auth
#   Auth credentials for API
#   Either of:
#   * [String]: Bearer Token
#   * [Struct]:
#     * zabbix_user [String]: API username
#     * zabbix_pass [String]: API password
# @param apache_use_ssl Whether to use ssl or not.
class zabbix::resources::web (
  String[1] $zabbix_url,
  Variant[
      String[1],
      Struct[{
          zabbix_user => String[1],
          zabbix_pass => String[1],
      }]
  ] $zabbix_auth,
  Boolean   $apache_use_ssl,
) {
  file { '/etc/zabbix/api.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('zabbix/api.conf.epp',
      {
        zabbix_url     => $zabbix_url,
        zabbix_auth    => $zabbix_auth,
        apache_use_ssl => $apache_use_ssl,
      }
    ),
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
