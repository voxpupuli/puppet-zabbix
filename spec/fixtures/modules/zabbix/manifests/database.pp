# == Class: zabbix::database
#
#  This will determine if the database should be created or not.
#
#  Please note:
#  This class will be called from zabbix::server or zabbix::proxy.
#  No need for calling this class manually.
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::database(
  $manage_database = '',
  $dbtype          = '',
  $zabbix_type     = '',
  $zabbix_version  = '',
  $db_name         = '',
  $db_user         = '',
  $db_pass         = '',
  $db_host         = '',
) {
  # If manage_database is true, we going to load the correct database class
  if $manage_database == true {
    case $dbtype {
      'postgresql': {
        class { 'zabbix::database::postgresql':
          zabbix_type    => $zabbix_type,
          zabbix_version => $zabbix_version,
          db_name        => $db_name,
          db_user        => $db_user,
          db_pass        => $db_pass,
        }
      }
      'mysql': {
        class { 'zabbix::database::mysql':
          zabbix_type    => $zabbix_type,
          zabbix_version => $zabbix_version,
          db_name        => $db_name,
          db_user        => $db_user,
          db_pass        => $db_pass,
          db_host        => $db_host,
        }
      }
      default: {
        fail('Unrecognized database type for server.')
      }
    } # END case $dbtype
  }
}