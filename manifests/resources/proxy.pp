# == Class zabbix::resources::proxy
#
# This will create an resources into puppetdb
# for automatically configuring proxy agent into
# zabbix front-end.
#
# === Requirements
#
# Nothing.
#
# When manage_resource is set to true, this class
# will be loaded from 'zabbix::proxy'. So no need
# for loading this class manually.

class zabbix::resources::proxy (
  $hostname  = undef,
  $ipaddress = undef,
  $use_ip    = undef,
  $mode      = undef,
  $port      = undef,
  $templates = undef,
) {

    @@zabbix_proxy { $hostname:
      ipaddress      => $ipaddress,
      use_ip         => $use_ip,
      mode           => $mode,
      port           => $port,
      templates      => $templates,
      zabbix_url     => '',
      zabbix_user    => '',
      zabbix_pass    => '',
      apache_use_ssl => '',
    }

}
