# == Class: zabbix::database::postgresql
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
class zabbix::database::postgresql (
  $zabbix_type    = '',
  $zabbix_version = '',
  $db_name        = '',
  $db_user        = '',
  $db_pass        = '',
) {

  # Creating database
  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pass),
  }

  file { '/var/lib/pgsql/.pgpass':
    ensure  => present,
    mode    => '0600',
    owner   => 'postgres',
    group   => 'postgres',
    require => Postgresql::Server::Db[$db_name],
  }

  exec { 'update_pgpass':
    command => "echo localhost:5432:${db_name}:${db_user}:${db_pass} >> /var/lib/pgsql/.pgpass",
    path    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    unless  => "grep \"localhost:5432:${db_name}:${db_user}:${db_pass}\" /var/lib/pgsql/.pgpass",
    require => File['/var/lib/pgsql/.pgpass'],
  }

  case $zabbix_type {
    'proxy': {
      exec { 'zabbix_proxy_create.sql':
        command  => "cd /usr/share/doc/zabbix-proxy-pgsql-${zabbix_version}*/create && sudo -u postgres psql -h localhost -U ${db_user} -d ${db_name} -f schema.sql && touch schema.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create/schema.done",
        provider => 'shell',
        require  => [
          Exec['update_pgpass'],
          Package['zabbix-proxy'],
        ],
        notify   => Service['zabbix-proxy'],
      }
    }
    'server': {
      exec { 'zabbix_server_create.sql':
        command  => "cd /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create && sudo -u postgres psql -h localhost -U ${db_user} -d ${db_name} -f schema.sql && touch schema.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create/schema.done",
        provider => 'shell',
        require  => [
          Exec['update_pgpass'],
          Package['zabbix-server-pgsql'],
        ],
        notify   => Service['zabbix-server'],
      } ->
      exec { 'zabbix_server_images.sql':
        command  => "cd /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create && sudo -u postgres psql -h localhost -U ${db_user} -d ${db_name} -f images.sql && touch images.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create/images.done",
        provider => 'shell',
        require  => [
          Exec['update_pgpass'],
          Package['zabbix-server-pgsql'],
        ],
        notify   => Service['zabbix-server'],
      } ->
      exec { 'zabbix_server_data.sql':
        command  => "cd /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create && sudo -u postgres psql -h localhost -U ${db_user} -d ${db_name} -f data.sql && touch data.done",
        path     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless   => "test -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}*/create/data.done",
        provider => 'shell',
        require  => [
          Exec['update_pgpass'],
          Package['zabbix-server-pgsql'],
        ],
        notify   => Service['zabbix-server'],
      }
    }
    default: {
      fail 'We do not work.'
    }
  }
}
