# == Define zabbix::resources::userparameters
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
# will be loaded from 'zabbix::userparameters'. So
# no need for loading this class manually.
#
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
