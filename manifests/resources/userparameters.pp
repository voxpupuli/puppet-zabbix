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
  $hostname,
  $template,
) {

  @@zabbix_userparameters { "${hostname}_${name}":
    hostname       => $hostname,
    template       => $template,
    zabbix_url     => '',
    zabbix_user    => '',
    zabbix_pass    => '',
    apache_use_ssl => '',
  }

}
