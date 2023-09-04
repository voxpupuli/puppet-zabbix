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
  $zabbix_type                                                          = '',
  $zabbix_version                                                       = $zabbix::params::zabbix_version,
  $database_schema_path                                                 = '',
  $database_name                                                        = '',
  $database_user                                                        = '',
  Optional[Variant[String[1], Sensitive[String[1]]]] $database_password = undef,
  $database_host                                                        = '',
  Stdlib::Port::Unprivileged $database_port                             = 5432,
  $database_path                                                        = $zabbix::params::database_path,
) inherits zabbix::params {
  assert_private()

  $database_password_unsensitive = if $database_password =~ Sensitive[String] {
    $database_password.unwrap
  } else {
    $database_password
  }

  if ($database_schema_path == false) or ($database_schema_path == '') {
    if member(['CentOS', 'RedHat', 'OracleLinux', 'VirtuozzoLinux'], $facts['os']['name']) {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        $schema_path = '/usr/share/zabbix-sql-scripts/postgresql/'
      } elsif versioncmp($zabbix_version, '5.4') >= 0 {
        $schema_path = '/usr/share/doc/zabbix-sql-scripts/postgresql/'
      } else {
        $schema_path = "/usr/share/doc/zabbix-*-pgsql-${zabbix_version}*/"
      }
    } else {
      if versioncmp($zabbix_version, '6.0') >= 0 {
        $schema_path = '/usr/share/zabbix-sql-scripts/postgresql/'
      } elsif versioncmp($zabbix_version, '5.4') >= 0 {
        $schema_path = '/usr/share/doc/zabbix-sql-scripts/postgresql/'
      } else {
        $schema_path = '/usr/share/doc/zabbix-*-pgsql'
      }
    }
  } else {
    $schema_path = $database_schema_path
  }

  case $zabbix_type {
    'proxy': {
      $zabbix_proxy_create_sql = versioncmp($zabbix_version, '6.0') >= 0 ? {
        true  => "cd ${schema_path} && psql -h '${database_host}' -U '${database_user}' -p ${database_port} -d '${database_name}' -f proxy.sql && touch /etc/zabbix/.schema.done",
        false => "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && psql -h '${database_host}' -U '${database_user}' -p ${database_port} -d '${database_name}' -f schema.sql && touch /etc/zabbix/.schema.done"
      }
    }
    default: {
      $zabbix_server_create_sql = versioncmp($zabbix_version, '6.0') >= 0 ? {
        true  => "cd ${schema_path} && if [ -f server.sql.gz ]; then gunzip -f server.sql.gz ; fi && psql -h '${database_host}' -U '${database_user}' -p ${database_port} -d '${database_name}' -f server.sql && touch /etc/zabbix/.schema.done",
        false => "cd ${schema_path} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && psql -h '${database_host}' -U '${database_user}' -p ${database_port} -d '${database_name}' -f create.sql && touch /etc/zabbix/.schema.done"
      }
      $zabbix_server_images_sql = 'touch /etc/zabbix/.images.done'
      $zabbix_server_data_sql   = 'touch /etc/zabbix/.data.done'
    }
  }

  exec { 'update_pgpass':
    command => Sensitive("echo ${database_host}:${database_port}:${database_name}:${database_user}:${database_password_unsensitive} >> /root/.pgpass"),
    path    => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
    unless  => Sensitive("grep \"${database_host}:${database_port}:${database_name}:${database_user}:${database_password_unsensitive}\" /root/.pgpass"),
    require => File['/root/.pgpass'],
  }

  file { '/root/.pgpass':
    ensure => file,
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }

  case $zabbix_type {
    'proxy': {
      exec { 'zabbix_proxy_create.sql':
        command  => $zabbix_proxy_create_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
        require  => Exec['update_pgpass'],
      }
    }
    'server': {
      exec { 'zabbix_server_create.sql':
        command  => $zabbix_server_create_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
        require  => Exec['update_pgpass'],
      }
      -> exec { 'zabbix_server_images.sql':
        command  => $zabbix_server_images_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.images.done',
        provider => 'shell',
        require  => Exec['update_pgpass'],
      }
      -> exec { 'zabbix_server_data.sql':
        command  => $zabbix_server_data_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.data.done',
        provider => 'shell',
        require  => Exec['update_pgpass'],
      }
    }
    default: {
      fail 'We do not work.'
    }
  }
}
