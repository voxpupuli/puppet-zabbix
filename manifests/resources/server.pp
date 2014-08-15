class zabbix::resources::server (
  $zabbix_url,
  $zabbix_user,
  $zabbix_pass,
) {

  notify { 'We will be running': }

  Zabbix_proxy <<| |>> {
    zabbix_url  => $zabbix_url,
    zabbix_user => $zabbix_user,
    zabbix_pass => $zabbix_pass,
  } ->
  Zabbix_host <<| |>> {
    zabbix_url  => $zabbix_url,
    zabbix_user => $zabbix_user,
    zabbix_pass => $zabbix_pass,
  } ->
  Zabbix_userparameters <<| |>> {
    zabbix_url  => $zabbix_url,
    zabbix_user => $zabbix_user,
    zabbix_pass => $zabbix_pass,
  }
}
