# == Class: zabbix::database
#
#  This will install the correct database and one or more users
#  for correct usage
#
# === Requirements
#
#  The following is needed (or):
#   - puppetlabs-mysql
#   - puppetlabs-postgresql
#
# === Parameters
#
# [*zabbix_type*]
#   The type of zabbix which is used: server or proxy.
#   This will determine what sql files will be loaded into database.
#
# [*zabbix_web*]
#   This is the hostname of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   mysql. When single node: localhost
#
# [*zabbix_web_ip*]
#   This is the ip address of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   postgresql. When single node: 127.0.0.1
#
# [*zabbix_server*]
#   This is the FQDN for the host running zabbix-server. This parameter
#   is used when database_type = mysql. Default: localhost
#
# [*zabbix_server_ip*]
#   This is the actual ip address of the host running zabbix-server
#   This parameter is used when database_type = postgresql. Default:
#   127.0.0.1
#
# [*zabbix_proxy*]
#   This is the FQDN for the host running zabbix-proxy. This parameter
#   is used when database_type = mysql. Default: localhost
#
# [*zabbix_proxy_ip*]
#   This is the actual ip address of the host running zabbix-proxy
#   This parameter is used when database_type = postgresql. Default:
#   127.0.0.1
#
# [*manage_database*]
#   When set to true, it will create the database and will load
#   the sql files for basic setup. Otherwise you should do this manually.
#
# [*database_type*]
#   The database which is used: postgresql or mysql
#
# [*database_name*]
#   The name of the database. Default: zabbix-server
#
# [*database_user*]
#   The user which is used for connecting to the database
#   default: zabbix-server
#
# [*database_password*]
#   The password of the database_user.
#
# [*database_host*]
#   The hostname of the server running the database.
#   default: localhost
#
# [* database_charset*]
#   The default charset of the database.
#   default: utf8
#
# [* database_collate*]
#   The default collation of the database.
#   default: utf8_general_ci
#
# === Example
#
#   When running everything on a single node, please check
#   documentation in init.pp
#   The following is an example of an multiple host setup:
#
#   node 'wdpuppet04.dj-wasabi.local' {
#     #  class { 'postgresql::server':
#     #    listen_addresses => '192.168.20.14'
#     #  }
#     class { 'mysql::server':
#       override_options => {
#         'mysqld'       => {
#           'bind_address' => '192.168.20.14',
#         },
#       },
#     }
#     class { 'zabbix::database':
#       database_type     => 'mysql',
#       #zabbix_front_ip  => '192.168.20.12',
#       #zabbix_server_ip => '192.168.20.13',
#       zabbix_server     => 'wdpuppet03.dj-wasabi.local',
#       zabbix_web        => 'wdpuppet02.dj-wasabi.local',
#     }
#   }
#
#   The above example is when database_type = mysql. When you want to
#   use the postgresql as database, uncomment the lines of postgresql
#   class and both *_ip parameters. Comment the mysql class and comment
#   the zabbix_server and zabbix_web parameter.
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::database(
  $zabbix_type          = 'server',
  $zabbix_web           = $zabbix::params::zabbix_web,
  $zabbix_web_ip        = $zabbix::params::zabbix_web_ip,
  $zabbix_server        = $zabbix::params::zabbix_server,
  $zabbix_server_ip     = $zabbix::params::zabbix_server_ip,
  $zabbix_proxy         = $zabbix::params::zabbix_proxy,
  $zabbix_proxy_ip      = $zabbix::params::zabbix_proxy_ip,
  $manage_database      = $zabbix::params::manage_database,
  $database_type        = $zabbix::params::database_type,
  $database_schema_path = $zabbix::params::database_schema_path,
  $database_name        = $zabbix::params::server_database_name,
  $database_user        = $zabbix::params::server_database_user,
  $database_password    = $zabbix::params::server_database_password,
  $database_host        = $zabbix::params::server_database_host,
  $database_charset     = $zabbix::params::server_database_charset,
  $database_collate     = $zabbix::params::server_database_collate,
) inherits zabbix::params {

  # So lets create the databases and load all files. This can only be
  # happen when manage_database is set to true (Default).
  if $manage_database == true {
    case $database_type {
      'postgresql': {
        # This is the PostgreSQL part.
        # Create the postgres database.
        postgresql::server::db { $database_name:
          user     => $database_user,
          owner    => $database_user,
          password => postgresql_password($database_user, $database_password),
          require  => Class['postgresql::server'],
        }

        # When every component has its own server, we have to allow those servers to
        # access the database from the network. Postgresl allows this via the
        # pg_hba.conf file. As this file only accepts ip addresses, the ip address
        # of server and web has to be supplied as an parameter.
        if $zabbix_web_ip != $zabbix_server_ip {
          postgresql::server::pg_hba_rule { 'Allow zabbix-server to access database':
            description => 'Open up postgresql for access from zabbix-server',
            type        => 'host',
            database    => $database_name,
            user        => $database_user,
            address     => "${zabbix_server_ip}/32",
            auth_method => 'md5',
          }

          postgresql::server::pg_hba_rule { 'Allow zabbix-web to access database':
            description => 'Open up postgresql for access from zabbix-web',
            type        => 'host',
            database    => $database_name,
            user        => $database_user,
            address     => "${zabbix_web_ip}/32",
            auth_method => 'md5',
          }
        } # END if $zabbix_web_ip != $zabbix_server_ip

        # This is some specific action for the zabbix-proxy. This is due to better
        # parameter naming.
        if $zabbix_type == 'proxy' {
          postgresql::server::pg_hba_rule { 'Allow zabbix-proxy to access database':
            description => 'Open up postgresql for access from zabbix-proxy',
            type        => 'host',
            database    => $database_name,
            user        => $database_user,
            address     => "${zabbix_proxy_ip}/32",
            auth_method => 'md5',
          }
        } # END if $zabbix_type == 'proxy'
      }
      'mysql': {
        # This is the MySQL part.

        # First we check what kind of zabbix component it is. We have to use clear names
        # as it may be confusing when you need to fill in the zabbix-proxy name into the
        # zabbix_server parameter. These are 2 different things. So we need to use an
        # if statement for this.
        if $zabbix_type == 'server' {
          mysql::db { $database_name:
            user     => $database_user,
            password => $database_password,
            charset  => $database_charset,
            collate  => $database_collate,
            host     => $zabbix_server,
            grant    => ['all'],
            require  => Class['mysql::server'],
          }
        }

        # And the proxy part.
        if $zabbix_type == 'proxy' {
          mysql::db { $database_name:
            user     => $database_user,
            password => $database_password,
            charset  => $database_charset,
            collate  => $database_collate,
            host     => $zabbix_proxy,
            grant    => ['all'],
            require  => Class['mysql::server'],
          }
        }

        # When the zabbix web and zabbix database aren't running on the same host, some
        # extra users/grants needs to be created.
        if $zabbix_web != $zabbix_server {
          mysql_user { "${database_user}@${zabbix_web}":
            ensure        => 'present',
            password_hash => mysql_password($database_password),
          }

          # And this is the grant part. It will grant the users which is created earlier
          # to the zabbix-server database with all rights, like the user for the zabbix
          # -server itself.
          mysql_grant { "${database_user}@${zabbix_web}/${database_name}.*":
            ensure     => 'present',
            options    => ['GRANT'],
            privileges => ['ALL'],
            table      => "${database_name}.*",
            user       => "${database_user}@${zabbix_web}",
            require    => [
              Class['mysql::server'],
              Mysql::Db[$database_name],
              Mysql_user["${database_user}@${zabbix_web}"]
            ],
          }
        } # END if $zabbix_web != $zabbix_server
      }
      'sqlite': {
        class { '::zabbix::database::sqlite': }
      }
      default: {
        fail('Unrecognized database type for server.')
      }
    } # END case $database_type
  }
}
