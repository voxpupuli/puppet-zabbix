# @summary This will upload an Zabbix Template (XML format)
# @param templ_name The name of the template. This name will be found in the Web interface
# @param templ_source The location of the XML file wich needs to be imported.
# @param zabbix_version The Zabbix version on which the template will be installed on.
# @param delete_missing_applications Deletes applications from zabbix that are not in the template when set to true
# @param delete_missing_drules Deletes discovery rules from zabbix that are not in the template when set to true
# @param delete_missing_graphs Deletes graphs from zabbix that are not in the template when set to true
# @param delete_missing_httptests Deletes web-scenarios from zabbix that are not in the template when set to true
# @param delete_missing_items Deletes items from zabbix that are not in the template when set to true
# @param delete_missing_templatescreens Deletes template-screens from zabbix that are not in the template when set to true
# @param delete_missing_triggers Deletes triggers from zabbix that are not in the template when set to true
# @example
#   zabbix::template { 'Template App MySQL':
#      templ_source => 'puppet:///modules/zabbix/MySQL.xml'
#   }
# @author Vladislav Tkatchev <vlad.tkatchev@gmail.com>
define zabbix::template (
  $templ_name                             = $title,
  $templ_source                           = '',
  String[1] $zabbix_version               = $zabbix::params::zabbix_version,
  Boolean $delete_missing_applications    = false,
  Boolean $delete_missing_drules          = false,
  Boolean $delete_missing_graphs          = false,
  Boolean $delete_missing_httptests       = false,
  Boolean $delete_missing_items           = false,
  Boolean $delete_missing_templatescreens = false,
  Boolean $delete_missing_triggers        = false,
) {
  zabbix::resources::template { $templ_name:
    template_name                  => $templ_name,
    template_source                => $templ_source,
    zabbix_version                 => $zabbix_version,
    delete_missing_applications    => $delete_missing_applications,
    delete_missing_drules          => $delete_missing_drules,
    delete_missing_graphs          => $delete_missing_graphs,
    delete_missing_httptests       => $delete_missing_httptests,
    delete_missing_items           => $delete_missing_items,
    delete_missing_templatescreens => $delete_missing_templatescreens,
    delete_missing_triggers        => $delete_missing_triggers,
  }
}
