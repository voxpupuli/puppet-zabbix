# @summary This will create resources into puppetdb for automatically configuring agent into zabbix front-end.
# @param template_dir The directory containing zabbix templates
# @param template_name The name of template.
# @param template_source Template source file.
# @param zabbix_version Zabbix version that the template will be installed on.
# @param delete_missing_applications Deletes applications from zabbix that are not in the template when set to true
# @param delete_missing_drules Deletes discovery rules from zabbix that are not in the template when set to true
# @param delete_missing_graphs Deletes graphs from zabbix that are not in the template when set to true
# @param delete_missing_httptests Deletes web-scenarios from zabbix that are not in the template when set to true
# @param delete_missing_items Deletes items from zabbix that are not in the template when set to true
# @param delete_missing_templatescreens Deletes template-screens from zabbix that are not in the template when set to true
# @param delete_missing_triggers Deletes triggers from zabbix that are not in the template when set to true
define zabbix::resources::template (
  $template_dir                           = $zabbix::params::zabbix_template_dir,
  $template_name                          = $title,
  $template_source                        = '',
  $zabbix_version                         = $zabbix::params::zabbix_version,
  Boolean $delete_missing_applications    = false,
  Boolean $delete_missing_drules          = false,
  Boolean $delete_missing_graphs          = false,
  Boolean $delete_missing_httptests       = false,
  Boolean $delete_missing_items           = false,
  Boolean $delete_missing_templatescreens = false,
  Boolean $delete_missing_triggers        = false,
) {
  file { "${template_dir}/${template_name}.xml":
    ensure => file,
    owner  => 'zabbix',
    group  => 'zabbix',
    source => $template_source,
  }

  @@zabbix_template { $template_name:
    template_source                => "${template_dir}/${template_name}.xml",
    zabbix_version                 => $zabbix_version,
    require                        => File["${template_dir}/${template_name}.xml"],
    delete_missing_applications    => $delete_missing_applications,
    delete_missing_drules          => $delete_missing_drules,
    delete_missing_graphs          => $delete_missing_graphs,
    delete_missing_httptests       => $delete_missing_httptests,
    delete_missing_items           => $delete_missing_items,
    delete_missing_templatescreens => $delete_missing_templatescreens,
    delete_missing_triggers        => $delete_missing_triggers,
  }
}
