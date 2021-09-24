# @summary This will create resources into puppetdb for automatically configuring proxy agent into zabbix front-end.
# @param hostname Hostname of the proxy.
# @param ipaddress The IP address of the machine running zabbix proxy.
# @param use_ip Whether to use ipadress instead of dns to connect.
# @param mode The kind of mode the proxy running. Active (0) or passive (1).
# @param port The port that the zabbix proxy is listening on.
class zabbix::resources::proxy (
  $hostname  = undef,
  $ipaddress = undef,
  $use_ip    = undef,
  $mode      = undef,
  $port      = undef,
) {
  @@zabbix_proxy { $hostname:
    ipaddress => $ipaddress,
    use_ip    => $use_ip,
    mode      => $mode,
    port      => $port,
  }
}
