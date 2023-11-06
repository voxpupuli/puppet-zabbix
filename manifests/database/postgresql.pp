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

  if $database_schema_path != false and $database_schema_path != '' {
    $schema_path = $database_schema_path
  } elsif versioncmp($zabbix_version, '6.0') >= 0 {
    $schema_path = '/usr/share/zabbix-sql-scripts/postgresql/'
  } elsif $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
    $schema_path = "/usr/share/doc/zabbix-*-pgsql-${zabbix_version}*/"
  } else {
    $schema_path = '/usr/share/doc/zabbix-*-pgsql'
  }

  $done_file = '/etc/zabbix/.schema.done'
  $schema_file = case $zabbix_type {
    'proxy': {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        'proxy.sql'
      } else {
        'schema.sql'
      }
    }
    default: {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        'server.sql'
      } else {
        'create.sql'
      }
    }
  }

  $command = "cd ${schema_path} && if [ -f ${schema_file}.gz ]; then zcat ${schema_file}.gz | psql ; else psql -f ${schema_file}; fi && touch ${done_file}"
  $exec_env = [
    "PGHOST=${database_host}",
    "PGPORT=${database_port}",
    "PGUSER=${database_user}",
    "PGPASSWORD=${database_password}",
    "PGDATABASE=${database_name}",
  ]

  exec { 'zabbix_create.sql':
    command     => $command,
    path        => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
    creates     => $done_file,
    provider    => 'shell',
    environment => $exec_env,
  }
}
