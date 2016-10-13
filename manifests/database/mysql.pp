# == Class: zabbix::database::mysql
#
#  This will install and load the sql files for the tables
#  and other data which is needed for zabbix.
#
#  Please note:
#  This class will be called from zabbix::database. No need for calling
#  this class manually.
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
  $zabbix_type          = '',
  $zabbix_version       = $zabbix::params::zabbix_version,
  $database_schema_path = '',
  $database_name        = '',
  $database_user        = '',
  $database_password    = '',
  $database_host        = '',
  $database_path        = $zabbix::params::database_path,) inherits zabbix::params {
  #
  # Adjustments for version 3.0 - structure of package with sqls differs from previous versions
  case $zabbix_version {
    /^3.\d+$/: {
      if ($database_schema_path == false) or ($database_schema_path == '') {
        $schema_path   = '/usr/share/doc/zabbix-*-mysql*'
      }
      else {
        $schema_path = $database_schema_path
      }

      case $zabbix_type {
        'proxy': {
          $zabbix_proxy_create_sql = "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done"
        }
        default: {
          $zabbix_server_create_sql = "cd ${schema_path} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < create.sql && touch /etc/zabbix/.schema.done"
          $zabbix_server_images_sql = 'touch /etc/zabbix/.images.done'
          $zabbix_server_data_sql   = 'touch /etc/zabbix/.data.done'
        }
      }
    }
    default: {
      if ($database_schema_path == false) or ($database_schema_path == '') {
        case $::osfamily {
          'RedHat': {
            $schema_path   = "/usr/share/doc/zabbix-*-mysql-${zabbix_version}*/create"
          }
          default : {
            $schema_path   = '/usr/share/zabbix-*-mysql'
          }
        }
      }
      else {
        $schema_path = $database_schema_path
      }
      case $zabbix_type {
        'proxy': {
          $zabbix_proxy_create_sql = "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done"
        }
        default: {
          $zabbix_server_create_sql = "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done"
          $zabbix_server_images_sql = "cd ${schema_path} && if [ -f images.sql.gz ]; then gunzip -f images.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < images.sql && touch /etc/zabbix/.images.done"
          $zabbix_server_data_sql   = "cd ${schema_path} && if [ -f data.sql.gz ]; then gunzip -f data.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < data.sql && touch /etc/zabbix/.data.done"
        }
      }
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
        require  => Package['zabbix-proxy-mysql'],
        notify   => Service['zabbix-proxy'],
      }
    }
    'server' : {
      exec { 'zabbix_server_create.sql':
        command  => $zabbix_server_create_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
      } ->
      exec { 'zabbix_server_images.sql':
        command  => $zabbix_server_images_sql,
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.images.done',
        provider => 'shell',
      } ->
      exec { 'zabbix_server_data.sql':
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
