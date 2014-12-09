#
class zabbix::database::remotepostgresql (
  $dbname = $zabbix::params::server_dbname,
  $dbuser = $zabbix::params::server_dbuser,
  $dbpassword = $zabbix::params::server_dbpassword,
) inherits zabbix::params {

  postgresql::server::db { $dbname:
    user     => $dbuser,
    password => postgresql_password($dbuser, $dbpassword),
  }
}
