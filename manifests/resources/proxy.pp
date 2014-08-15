class zabbix::resources::proxy (
  $hostname,
  $ipaddress,
  $use_ip,
  $mode,
  $port,
  $templates,
) {

    @@zabbix_proxy { $hostname:
      ipaddress   => $ipaddress,
      use_ip      => $use_ip,
      mode        => $mode,
      port        => $port,
      templates   => $templates,
      zabbix_url  => '',
      zabbix_user => '',
      zabbix_pass => '',
    }

}
