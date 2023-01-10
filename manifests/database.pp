# @summary This will install the correct database and one or more users for correct usage
# @param zabbix_type
#   The type of zabbix which is used: server or proxy.
#   This will determine what sql files will be loaded into database.
# @param zabbix_web
#   This is the hostname of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   mysql. When single node: localhost
# @param zabbix_web_ip
#   This is the ip address of the server which is running the
#   zabbix-web package. This parameter is used when database_type =
#   postgresql. When single node: 127.0.0.1
# @param zabbix_server
#   This is the FQDN for the host running zabbix-server. This parameter
#   is used when database_type = mysql. Default: localhost
# @param zabbix_server_ip
#   This is the actual ip address of the host running zabbix-server
#   This parameter is used when database_type = postgresql. Default:
#   127.0.0.1
# @param zabbix_proxy
#   This is the FQDN for the host running zabbix-proxy. This parameter
#   is used when database_type = mysql. Default: localhost
# @param zabbix_proxy_ip
#   This is the actual ip address of the host running zabbix-proxy
#   This parameter is used when database_type = postgresql. Default:
#   127.0.0.1
# @param manage_database
#   When set to true, it will create the database and will load
#   the sql files for basic setup. Otherwise you should do this manually.
# @param database_type The database which is used: postgresql or mysql
# @param database_schema_path The path to the directory containing the .sql schema files
# @param database_name The name of the database. Default: zabbix-server
# @param database_user The user which is used for connecting to the database
# @param database_password The password of the database_user.
# @param database_host The hostname of the server running the database.
# @param database_host_ip IP of the machine the database runs on.
# @param database_charset The default charset of the database.
# @param database_collate The default collation of the database.
# @param database_tablespace The tablespace the database will be created in. This setting only affects PostgreSQL databases.
# @example The following is an example of an multiple host setup:
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
# @author Werner Dijkerman ikben@werner-dijkerman.nl
class zabbix::database (
  $zabbix_type                                                          = 'server',
  $zabbix_web                                                           = $zabbix::params::zabbix_web,
  $zabbix_web_ip                                                        = $zabbix::params::zabbix_web_ip,
  $zabbix_server                                                        = $zabbix::params::zabbix_server,
  $zabbix_server_ip                                                     = $zabbix::params::zabbix_server_ip,
  $zabbix_proxy                                                         = $zabbix::params::zabbix_proxy,
  $zabbix_proxy_ip                                                      = $zabbix::params::zabbix_proxy_ip,
  $manage_database                                                      = $zabbix::params::manage_database,
  Zabbix::Databases $database_type                                      = $zabbix::params::database_type,
  $database_schema_path                                                 = $zabbix::params::database_schema_path,
  $database_name                                                        = $zabbix::params::server_database_name,
  $database_user                                                        = $zabbix::params::server_database_user,
  Optional[Variant[String[1], Sensitive[String[1]]]] $database_password = $zabbix::params::server_database_password,
  $database_host                                                        = $zabbix::params::server_database_host,
  $database_host_ip                                                     = $zabbix::params::server_database_host_ip,
  $database_charset                                                     = $zabbix::params::server_database_charset,
  $database_collate                                                     = $zabbix::params::server_database_collate,
  Optional[String[1]] $database_tablespace = $zabbix::params::server_database_tablespace,
) inherits zabbix::params {
  # So lets create the databases and load all files. This can only be
  # happen when manage_database is set to true (Default).
  if $manage_database == true {
    # Complain if database_tablespace is set and the database_type is not postgresql
    if ($database_tablespace and $database_type != 'postgresql') {
      fail("database_tablespace is set to '${database_tablespace}'. This setting is only useful for PostgreSQL databases.")
    }

    case $database_type {
      'postgresql': {
        # This is the PostgreSQL part.
        # Create the postgres database.
        postgresql::server::db { $database_name:
          user       => $database_user,
          owner      => $database_user,
          password   => postgresql::postgresql_password($database_user, $database_password),
          require    => Class['postgresql::server'],
          tablespace => $database_tablespace,
        }

        # When database not in some server with zabbix server include pg_hba_rule to server
        if ($database_host_ip != $zabbix_server_ip) or ($zabbix_web_ip != $zabbix_server_ip) {
          postgresql::server::pg_hba_rule { 'Allow zabbix-server to access database':
            description => 'Open up postgresql for access from zabbix-server',
            type        => 'host',
            database    => $database_name,
            user        => $database_user,
            address     => "${zabbix_server_ip}/32",
            auth_method => 'md5',
          }
        }

        # When every component has its own server, we have to allow those servers to
        # access the database from the network. Postgresql allows this via the
        # pg_hba.conf file. As this file only accepts ip addresses, the ip address
        # of server and web has to be supplied as an parameter.
        if $zabbix_web_ip != $zabbix_server_ip {
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
        class { 'zabbix::database::sqlite': }
      }
      default: {
        fail('Unrecognized database type for server.')
      }
    } # END case $database_type
  }
}
