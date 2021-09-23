# @summary This will upload an Zabbix Template (XML format)
# @param templ_name The name of the template. This name will be found in the Web interface
# @param templ_source The location of the XML file wich needs to be imported.
# @param zabbix_version The Zabbix version on which the template will be installed on.
# @example
#   zabbix::template { 'Template App MySQL':
#      templ_source => 'puppet:///modules/zabbix/MySQL.xml'
#   }
# @author Vladislav Tkatchev <vlad.tkatchev@gmail.com>
define zabbix::template (
  $templ_name     = $title,
  $templ_source   = '',
  String[1] $zabbix_version = $zabbix::params::zabbix_version,
) {
  zabbix::resources::template { $templ_name:
    template_name   => $templ_name,
    template_source => $templ_source,
    zabbix_version  => $zabbix_version,
  }
}
