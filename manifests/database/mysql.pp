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
  $zabbix_type    = '',
  $zabbix_version = '',
  $db_name        = '',
  $db_user        = '',
  $db_pass        = '',
  $db_host        = '',
) {

  case $::operatingsystem {
    'centos','redhat','oraclelinux' : {
      $zabbix_path = "/usr/share/doc/zabbix-*-mysql-${zabbix_version}*/create"
    }
    default : {
      $zabbix_path = '/usr/share/zabbix-*-mysql'
    }
  }

  # Create the database
  mysql::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => $db_host,
    grant    => ['all'],
  }

  # Loading the sql files.
  case $zabbix_type {
    'proxy': {
      exec { 'zabbix_proxy_create.sql':
        command  => "cd ${zabbix_path} && mysql -u ${db_user} -p${db_pass} -D ${db_name} < schema.sql && touch schema.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f ${zabbix_path}/schema.done",
        provider => 'shell',
        require  => Package['zabbix-proxy-mysql'],
        notify   => Service['zabbix-proxy'],
      }
    }
    'server': {
      exec { 'zabbix_server_create.sql':
        command  => "cd ${zabbix_path} && mysql -u ${db_user} -p${db_pass} -D ${db_name} < schema.sql && touch schema.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f ${zabbix_path}/schema.done",
        provider => 'shell',
        require  => Package['zabbix-server-mysql'],
        notify   => Service['zabbix-server'],
      } ->
      exec { 'zabbix_server_images.sql':
        command  => "cd ${zabbix_path} && mysql -u ${db_user} -p${db_pass} -D ${db_name} < images.sql && touch images.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f ${zabbix_path}/images.done",
        provider => 'shell',
        require  => Package['zabbix-server-mysql'],
        notify   => Service['zabbix-server'],
      } ->
      exec { 'zabbix_server_data.sql':
        command  => "cd ${zabbix_path} && mysql -u ${db_user} -p${db_pass} -D ${db_name} < data.sql && touch data.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f ${zabbix_path}/data.done",
        provider => 'shell',
        require  => Package['zabbix-server-mysql'],
        notify   => Service['zabbix-server'],
      }
    }
    default: {
      fail 'We do not work.'
    }
  } # END case $zabbix_type
}