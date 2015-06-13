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
  $database_path        = $zabbix::params::database_path,
) {
# Allow to customize the path to the Database Schema,
  if ! $database_schema_path {
    case $::operatingsystem {
      'centos','redhat','oraclelinux' : {
            $schema_path   = "/usr/share/doc/zabbix-*-mysql-${zabbix_version}*/create"
          }
        default : {
          $schema_path   = '/usr/share/zabbix-*-mysql'
      }
    }
  }else {
      $schema_path = $database_schema_path
  }
  # Loading the sql files.
  case $zabbix_type {
    'proxy': {
      exec { 'zabbix_proxy_create.sql':
        command  => "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done",
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
        require  => Package['zabbix-proxy-mysql'],
        notify   => Service['zabbix-proxy'],
      }
    }
    'server': {
      exec { 'zabbix_server_create.sql':
        command  => "cd ${schema_path} && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < schema.sql && touch /etc/zabbix/.schema.done",
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.schema.done',
        provider => 'shell',
      } ->
      exec { 'zabbix_server_images.sql':
        command  => "cd ${schema_path} && if [ -f images.sql.gz ]; then gunzip images.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < images.sql && touch /etc/zabbix/.images.done",
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.images.done',
        provider => 'shell',
      } ->
      exec { 'zabbix_server_data.sql':
        command  => "cd ${schema_path} && if [ -f data.sql.gz ]; then gunzip data.sql.gz ; fi && mysql -h '${database_host}' -u '${database_user}' -p'${database_password}' -D '${database_name}' < data.sql && touch /etc/zabbix/.data.done",
        path     => "/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:${database_path}",
        unless   => 'test -f /etc/zabbix/.data.done',
        provider => 'shell',
      }
    }
    default: {
      fail 'We do not work.'
    }
  } # END case $zabbix_type
}
