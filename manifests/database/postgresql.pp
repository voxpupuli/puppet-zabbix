# @summary This will install and load the sql files for the tables and other data which is needed for zabbix.
# @api private
# @param zabbix_type Zabbix component type. Can be one of: proxy, server
# @param zabbix_version This is the zabbix version
# @param database_schema_path The path to the directory containing the .sql schema files
# @param database_name Name of the database to connect to
# @param database_user Username to use to connect to the database
# @param database_password Password to use to connect to the database
# @param database_host Hostname to use to connect to the database
# @param database_port Database port to be used for the import process.
# @param database_path Path to the database executable
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
class zabbix::database::postgresql (
  $zabbix_type                                        = '',
  $zabbix_version                                     = $zabbix::params::zabbix_version,
  $database_schema_path                               = '',
  $database_name                                      = '',
  $database_user                                      = '',
  $database_password                                  = '',
  $database_host                                      = '',
  Stdlib::Port::Unprivileged $database_port           = 5432,
  $database_path                                      = $zabbix::params::database_path,
) inherits zabbix::params {
  assert_private()

  if ($database_schema_path == false) or ($database_schema_path == '') {
    if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        $schema_path = '/usr/share/zabbix-sql-scripts/postgresql/'
      } else {
        $schema_path = "/usr/share/doc/zabbix-*-pgsql-${zabbix_version}*/"
      }
    } else {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        $schema_path = '/usr/share/zabbix-sql-scripts/postgresql/'
      } else {
        $schema_path = '/usr/share/doc/zabbix-*-pgsql'
      }
    }
  } else {
    $schema_path = $database_schema_path
  }

  case $zabbix_type {
    'proxy': {
      $zabbix_create_sql = versioncmp($zabbix_version, '6.0') >= 0 ? {
        true  => "cd ${schema_path} && psql -f proxy.sql && touch /etc/zabbix/.schema.done",
        false => "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && psql -f schema.sql && touch /etc/zabbix/.schema.done"
      }
    }
    default: {
      $zabbix_create_sql = versioncmp($zabbix_version, '6.0') >= 0 ? {
        true  => "cd ${schema_path} && if [ -f server.sql.gz ]; then gunzip -f server.sql.gz ; fi && psql -f server.sql && touch /etc/zabbix/.schema.done",
        false => "cd ${schema_path} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && psql -f create.sql && touch /etc/zabbix/.schema.done"
      }
    }
  }

  $exec_env = [
    "PGHOST=${database_host}",
    "PGPORT=${database_port}",
    "PGUSER=${database_user}",
    "PGPASSWORD=${database_password}",
    "PGDATABASE=${database_name}",
  ]

  exec { 'zabbix_create.sql':
    command     => $zabbix_create_sql,
    path        => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
    unless      => 'test -f /etc/zabbix/.schema.done',
    provider    => 'shell',
    environment => $exec_env,
  }
}
