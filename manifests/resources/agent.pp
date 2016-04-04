# == Class zabbix::resources::agent
#
# This will create an resources into puppetdb
# for automatically configuring agent into
# zabbix front-end.
#
# === Requirements
#
# Nothing.
#
# When manage_resource is set to true, this class
# will be loaded from 'zabbix::agent'. So no need
# for loading this class manually.
#
#
class zabbix::resources::agent (
  $hostname      = undef,
  $ipaddress     = undef,
  $use_ip        = undef,
  $port          = undef,
  $group         = undef,
  $group_create  = undef,
  $templates     = undef,
  $proxy         = undef,
) {

  @@zabbix_host { $hostname:
    ipaddress      => $ipaddress,
    use_ip         => $use_ip,
    port           => $port,
    group          => $group,
    group_create   => $group_create,
    templates      => $templates,
    proxy          => $proxy,
    zabbix_url     => '',
    zabbix_user    => '',
    zabbix_pass    => '',
    apache_use_ssl => '',
  }
}
