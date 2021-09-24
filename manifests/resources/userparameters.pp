# @summary This will create resources into puppetdb for automatically configuring agent into zabbix front-end.
# @param ensure Ensure resource.
# @param hostname Hostname of the machine.
# @param template Template which should be attached to this host.
define zabbix::resources::userparameters (
  $ensure,
  $hostname,
  $template,
) {
  @@zabbix_userparameters { "${hostname}_${name}":
    ensure   => $ensure,
    hostname => $hostname,
    template => $template,
  }
}
