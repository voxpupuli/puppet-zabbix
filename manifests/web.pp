# == Class: zabbix::web
#
#  This will install the zabbix-web package and install an virtual host.
#
# === Requirements
#
#  The following is needed (or):
#   - puppetlabs-apache
#
# === Parameters
#
# [*zabbix_url*]
#   Url on which zabbix needs to be available. Will create an vhost in
#   apache. Only needed when manage_vhost is set to true.
#   Example: zabbix.example.com
#
# [*database_type*]
#   Type of database. Can use the following 2 databases:
#   - postgresql
#   - mysql
#
# [*zabbix_version*]
#   This is the zabbix version.
#   Example: 2.4
#
# [*zabbix_timezone*]
#   The current timezone for vhost configuration needed for the php timezone.
#   Example: Europe/Amsterdam
#
# [*zabbix_package_state*]
#   The state of the package that needs to be installed: present or latest.
#   Default: present
#
# [*manage_vhost*]
#   When true, it will create an vhost for apache. The parameter zabbix_url
#   has to be set.
#
# [*manage_resouces*]
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
#
# [*apache_use_ssl*]
#   Will create an ssl vhost. Also nonssl vhost will be created for redirect
#   nonssl to ssl vhost.
#
# [*apache_ssl_cert*]
#   The location of the ssl certificate file. You'll need to make sure this
#   file is present on the system, this module will not install this file.
#
# [*apache_ssl_key*]
#   The location of the ssl key file. You'll need to make sure this file is
#   present on the system, this module will not install this file.
#
# [*apache_ssl_cipher*]
#   The ssl cipher used. Cipher is used from this website:
#   https://wiki.mozilla.org/Security/Server_Side_TLS
#
# [*apache_ssl_chain*}
#   The ssl chain file.
#
# [*zabbix_api_user*]
#   Name of the user which the api should connect to. Default: Admin
#
# [*zabbix_api_pass*]
#   Password of the user which connects to the api. Default: zabbix
#
# [*database_host*]
#   Database host name.
#
# [*database_name*]
#   Database name.
#
# [*database_schema*]
#   Schema name. used for ibm db2.
#
# [*database_user*]
#   Database user. ignored for sqlite.
#
# [*database_password*]
#   Database password. ignored for sqlite.
#
# [*database_socket*]
#   Path to mysql socket.
#
# [*database_port*]
#   Database port when not using local socket. Ignored for sqlite.
#
# [*zabbix_server*]
#   The fqdn name of the host running the zabbix-server. When single node:
#   localhost
#
# [*zabbix_listenport*]
#   The port on which the zabbix-server is listening. Default: 10051
#
# === Example
#
#   When running everything on a single node, please check
#   documentation in init.pp
#   The following is an example of an multiple host setup:
#
#   node 'wdpuppet02.dj-wasabi.local' {
#     class { 'apache':
#         mpm_module => 'prefork',
#     }
#     class { 'apache::mod::php': }
#     class { 'zabbix::web':
#       zabbix_url    => 'zabbix.dj-wasabi.nl',
#       zabbix_server => 'wdpuppet03.dj-wasabi.local',
#       database_host => 'wdpuppet04.dj-wasabi.local',
#       database_type => 'mysql',
#     }
#   }
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::web (
  $zabbix_url              = '',
  $database_type           = $zabbix::params::database_type,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $zabbix_timezone         = $zabbix::params::zabbix_timezone,
  $zabbix_package_state    = $zabbix::params::zabbix_package_state,
  $manage_vhost            = $zabbix::params::manage_vhost,
  $manage_resources        = $zabbix::params::manage_resources,
  $apache_use_ssl          = $zabbix::params::apache_use_ssl,
  $apache_ssl_cert         = $zabbix::params::apache_ssl_cert,
  $apache_ssl_key          = $zabbix::params::apache_ssl_key,
  $apache_ssl_cipher       = $zabbix::params::apache_ssl_cipher,
  $apache_ssl_chain        = $zabbix::params::apache_ssl_chain,
  $zabbix_api_user         = $zabbix::params::server_api_user,
  $zabbix_api_pass         = $zabbix::params::server_api_pass,
  $database_host           = $zabbix::params::server_database_host,
  $database_name           = $zabbix::params::server_database_name,
  $database_schema         = $zabbix::params::server_database_schema,
  $database_user           = $zabbix::params::server_database_user,
  $database_password       = $zabbix::params::server_database_password,
  $database_socket         = $zabbix::params::server_database_socket,
  $database_port           = $zabbix::params::server_database_port,
  $zabbix_server           = $zabbix::params::zabbix_server,
  $zabbix_listenport       = $zabbix::params::server_listenport,
) inherits zabbix::params {

  include zabbix::repo

  # use the correct db.
  case $database_type {
    'postgresql': {
      $db = 'pgsql'
      $db_port = '5432'
    }
    'mysql': {
      $db = 'mysql'
      $db_port = '3306'
    }
    default: {
      fail('unrecognized database type for server.')
    }
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    include ruby::dev

    # Installing the zabbixapi gem package. We need this gem for
    # communicating with the zabbix-api. This is way better then
    # doing it ourself.
    package { 'zabbixapi':
      ensure   => "${zabbix_version}.0",
      provider => $::puppetgem,
      require  => Class['ruby::dev'],
    } ->
    class { 'zabbix::resources::web':
      zabbix_url     => $zabbix_url,
      zabbix_user    => $zabbix_api_user,
      zabbix_pass    => $zabbix_api_pass,
      apache_use_ssl => $apache_use_ssl,
    }
  }

  case $::operatingsystem {
    'ubuntu', 'debian' : {
      package { "php5-${db}":
        ensure => present,
      } ->
      package { 'zabbix-frontend-php':
        ensure => $zabbix_package_state,
        before => File['/etc/zabbix/web/zabbix.conf.php'],
      }
    }
    default : {
      package { "zabbix-web-${db}":
        ensure  => $zabbix_package_state,
        before  => [
          File['/etc/zabbix/web/zabbix.conf.php'],
          Package['zabbix-web']
        ],
        require => Class['zabbix::repo'],
      }
      package { 'zabbix-web':
        ensure => $zabbix_package_state,
      }
    }
  } # END case $::operatingsystem

  # Webinterface config file
  file { '/etc/zabbix/web/zabbix.conf.php':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    replace => true,
    content => template('zabbix/web/zabbix.conf.php.erb'),
  }

  # Is set to true, it will create the apache vhost.
  if $manage_vhost {
    include apache
    # Check if we use ssl. If so, we also create an non ssl
    # vhost for redirect traffic from non ssl to ssl site.
    if $apache_use_ssl {
      # Listen port
      $apache_listen_port = '443'

      # We create nonssl vhost for redirecting non ssl
      # traffic to https.
      apache::vhost { "${zabbix_url}_nonssl":
        docroot        => '/usr/share/zabbix',
        manage_docroot => false,
        port           => '80',
        servername     => $zabbix_url,
        ssl            => false,
        rewrites       => [
          {
            comment      => 'redirect all to https',
            rewrite_cond => ['%{SERVER_PORT} !^443$'],
            rewrite_rule => ["^/(.*)$ https://${zabbix_url}/\$1 [L,R]"],
          }
        ],
      }
    } else {
      # So no ssl, so default port 80
      $apache_listen_port = '80'
    }

    # Check which version of Apache we're using
    if versioncmp($::apache::apache_version, '2.4') >= 0 {
      $directory_allow = { 'require' => 'all granted', }
      $directory_deny = { 'require' => 'all denied', }
    } else {
      $directory_allow = { 'allow' => 'from all', 'order' => 'Allow,Deny', }
      $directory_deny = { 'deny' => 'from all', 'order' => 'Deny,Allow', }
    }

    apache::vhost { $zabbix_url:
      docroot         => '/usr/share/zabbix',
      port            => $apache_listen_port,
      directories     => [
        merge({
          path     => '/usr/share/zabbix',
          provider => 'directory',
        }, $directory_allow),
        merge({
          path     => '/usr/share/zabbix/conf',
          provider => 'directory',
        }, $directory_deny),
        merge({
          path     => '/usr/share/zabbix/api',
          provider => 'directory',
        }, $directory_deny),
        merge({
          path     => '/usr/share/zabbix/include',
          provider => 'directory',
        }, $directory_deny),
        merge({
          path     => '/usr/share/zabbix/include/classes',
          provider => 'directory',
        }, $directory_deny),
      ],
      custom_fragment => "
   php_value max_execution_time 300
   php_value memory_limit 128M
   php_value post_max_size 16M
   php_value upload_max_filesize 2M
   php_value max_input_time 300
   php_value always_populate_raw_post_data -1
   # Set correct timezone
   php_value date.timezone ${zabbix_timezone}",
      rewrites        => [
        {
          rewrite_rule => ['^$ /index.php [L]'] }
      ],
      ssl             => $apache_use_ssl,
      ssl_cert        => $apache_ssl_cert,
      ssl_key         => $apache_ssl_key,
      ssl_cipher      => $apache_ssl_cipher,
      ssl_chain       => $apache_ssl_chain,
      require         => File['/etc/zabbix/web/zabbix.conf.php'],
    }
  } # END if $manage_vhost
}
