# @summary This will create resources into puppetdb for automatically configuring agent into zabbix front-end.
# @param template_dir The directory containing zabbix templates
# @param template_name The name of template.
# @param template_source Template source file.
# @param zabbix_version Zabbix version that the template will be installed on.
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
