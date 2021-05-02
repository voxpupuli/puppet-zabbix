# == Define zabbix::template
#
#  This will upload an Zabbix Template (XML format)
#
# === Requirements
#
# === Parameters
#
# [*templ_name*]
#  The name of the template. This name will be found in the Web interface
#
# [*templ_source*]
#  The location of the XML file wich needs to be imported.
#
# [*zabbix_version*]
#  The Zabbix version on which the template will be installed on.
#
# === Example
#
#  zabbix::template { 'Template App MySQL':
#    templ_source => 'puppet:///modules/zabbix/MySQL.xml'
#  }
#
# === Authors
#
# Author Name: vlad.tkatchev@gmail.com
#
# === Copyright
#
# Copyright 2015  Vladislav Tkatchev
#
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
