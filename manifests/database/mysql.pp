# == Class: zabbix::database::mysql
#
#  This will install and load the sql files for the tables
#  and other data which is needed for zabbix.
#
#  Please note:
#  This class will be called from zabbix::server or zabbix::proxy.
#  No need for calling this class manually.
#
# === Parameters
#
# [*database_port*]
#  Database port to be used for the import process.
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::database::mysql (
  $zabbix_type                                        = '',
  $zabbix_version                                     = $zabbix::params::zabbix_version,
  $database_schema_path                               = '',
  $database_name                                      = '',
  $database_user                                      = '',
  $database_password                                  = '',
  $database_host                                      = '',
  Optional[Stdlib::Port::Unprivileged] $database_port = undef,
  $database_path                                      = $zabbix::params::database_path,
) inherits zabbix::params {
  assert_private()

  if ($database_schema_path == false) or ($database_schema_path == '') {
    $schema_path   = '/usr/share/doc/zabbix-*-mysql*'
  }
  else {
    $schema_path = $database_schema_path
  }

  if $database_port != undef {
    $port = "-P ${database_port} "
  } else {
    $port = ''
  }

  case $zabbix_type {
    'proxy': {
      $zabbix_proxy_create_sql = "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' ${port}-D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done"
    }
    default: {
      $zabbix_server_create_sql = "cd ${schema_path} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' ${port}-D '${database_name}' < create.sql && touch /etc/zabbix/.schema.done"
      $zabbix_server_images_sql = 'touch /etc/zabbix/.images.done'
      $zabbix_server_data_sql   = 'touch /etc/zabbix/.data.done'
    }
  }

  # Loading the sql files.
  case $zabbix_type {
    'proxy'  : {
      exec { 'zabbix_proxy_create.sql':
        command  => $zabbix_proxy_create_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
      }
    }
    'server' : {
      exec { 'zabbix_server_create.sql':
        command  => $zabbix_server_create_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
      }
      -> exec { 'zabbix_server_images.sql':
        command  => $zabbix_server_images_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.images.done',
        provider => 'shell',
      }
      -> exec { 'zabbix_server_data.sql':
        command  => $zabbix_server_data_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.data.done',
        provider => 'shell',
      }
    }
    default  : {
      fail 'We do not work.'
    }
  } # END case $zabbix_type
}
