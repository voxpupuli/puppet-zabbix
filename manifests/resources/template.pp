# == Class zabbix::resources::template
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
# will be loaded from 'zabbix::template'. So no need
# for loading this class manually.
#
#
define zabbix::resources::template (
  $template_dir    = $zabbix::params::zabbix_template_dir,
  $template_name   = $title,
  $template_source = '',
  $zabbix_version  = $zabbix::params::zabbix_version,
) {
  file { "${template_dir}/${template_name}.xml":
    ensure => file,
    owner  => 'zabbix',
    group  => 'zabbix',
    source => $template_source,
  }

  @@zabbix_template { $template_name:
    #template_source => $template_source,
    template_source => "${template_dir}/${template_name}.xml",
    zabbix_version  => $zabbix_version,
    require         => File["${template_dir}/${template_name}.xml"],
  }
}
