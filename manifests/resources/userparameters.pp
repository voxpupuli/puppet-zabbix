define zabbix::resources::userparameters (
  $hostname,
  $template,
) {
  
  @@zabbix_userparameters { "${hostname}_${name}":
    hostname    => $hostname,
    template    => $template,
    zabbix_url  => '',
    zabbix_user => '',
    zabbix_pass => '',
  }

}
