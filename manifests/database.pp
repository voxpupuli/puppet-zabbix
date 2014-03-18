#
class zabbix::database(
  $manage_database = undef,
  $dbtype          = undef,
  $zabbix_type     = undef,
  $zabbix_version  = undef,
  $db_name         = undef,
  $db_user         = undef,
  $db_pass         = undef,
) {

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
        }
      }
      'sqlite','sqlite3': {
        #class { 'zabbix::database::mysql':
        #}
      }
      default: {
        fail('Unrecognized database type for server.')
      }
    }
  }
}