# @summary This will install the zabbix-web package and install an virtual host.
# @param zabbix_url
#   Url on which zabbix needs to be available. Will create an vhost in
#   apache. Only needed when manage_vhost is set to true.
#   Example: zabbix.example.com
# @param database_type
#   Type of database. Can use the following 2 databases:
#   - postgresql
#   - mysql
# @param manage_repo
#   When true, it will create repository for installing the webinterface.
# @param zabbix_version This is the zabbix version.
# @param zabbix_timezone The current timezone for vhost configuration needed for the php timezone. Example: Europe/Amsterdam
# @param zabbix_template_dir The directory where all templates are stored before uploading via API
# @param zabbix_package_state The state of the package that needs to be installed: present or latest.
# @param web_config_owner Which user should own the web interface configuration file.
# @param web_config_group Which group should own the web interface configuration file.
# @param manage_vhost When true, it will create an vhost for apache. The parameter zabbix_url has to be set.
# @param default_vhost
#   When true priority of 15 is passed to zabbix vhost which would end up
#   with marking zabbix vhost as default one, when false priority is set to 25
# @param manage_resources
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
# @param apache_use_ssl
#   Will create an ssl vhost. Also nonssl vhost will be created for redirect
#   nonssl to ssl vhost.
# @param apache_ssl_cert
#   The location of the ssl certificate file. You'll need to make sure this
#   file is present on the system, this module will not install this file.
# @param apache_ssl_key
#   The location of the ssl key file. You'll need to make sure this file is
#   present on the system, this module will not install this file.
# @param apache_ssl_cipher
#   The ssl cipher used. Cipher is used from this website:
#   https://wiki.mozilla.org/Security/Server_Side_TLS
# @param apache_ssl_chain The ssl chain file.
# @param apache_listen_ip The IP the apache service should listen on.
# @param apache_listenport The port for the apache vhost.
# @param apache_listenport_ssl The port for the apache SSL vhost.
# @param zabbix_api_user Name of the user which the api should connect to. Default: Admin
# @param zabbix_api_pass Password of the user which connects to the api. Default: zabbix
# @param zabbix_api_access Which host has access to the api. Default: no restriction
# @param database_host Database host name.
# @param database_name Database name.
# @param database_schema Schema name. used for ibm db2.
# @param database_double_ieee754
#   Enable extended range of float values for new installs of Zabbix >= 5.0 and
#   after patching upgraded installs to 5.0 or greater.
#   https://www.zabbix.com/documentation/5.0/manual/installation/upgrade_notes_500#enabling_extended_range_of_numeric_float_values
# @param database_user Database user. ignored for sqlite.
# @param database_password Database password. ignored for sqlite.
# @param database_socket Path to mysql socket.
# @param database_port Database port when not using local socket. Ignored for sqlite.
# @param zabbix_server The fqdn name of the host running the zabbix-server. When single node: localhost
# @param zabbix_server_name
#   The fqdn name of the host running the zabbix-server. When single node:
#   localhost
#   This can also be used to upave a different name such as "Zabbix DEV"
# @param zabbix_listenport The port on which the zabbix-server is listening. Default: 10051
# @param apache_php_max_execution_time Max execution time for php. Default: 300
# @param apache_php_memory_limit PHP memory size limit. Default: 128M
# @param apache_php_post_max_size PHP maximum post size data. Default: 16M
# @param apache_php_upload_max_filesize PHP maximum upload filesize. Default: 2M
# @param apache_php_max_input_time Max input time for php. Default: 300
# @param apache_php_always_populate_raw_post_data Default: -1
# @param apache_php_max_input_vars Max amount of vars for GET/POST requests
# @param ldap_cacert Set location of ca_cert used by LDAP authentication.
# @param ldap_clientcert Set location of client cert used by LDAP authentication.
# @param ldap_clientkey Set location of client key used by LDAP authentication.
# @param ldap_reqcert Specifies what checks to perform on a server certificate
# @param saml_sp_key The location of the SAML Service Provider Key file.
# @param saml_sp_cert The location of the SAML Service Provider Certificate.
# @param saml_idp_cert The location of the SAML Identity Provider Certificate.
# @param saml_settings A hash of additional SAML SSO settings.
# @param puppetgem Provider for the zabbixapi gem package.
# @param manage_selinux Whether we should manage SELinux rules.
# @param apache_vhost_custom_params Additional parameters to pass to apache::vhost.
# @example For multiple host setup:
#   node 'wdpuppet02.dj-wasabi.local' {
#     class { 'apache':
#         mpm_module => 'prefork',
#     }
#     class { 'zabbix::web':
#       zabbix_url    => 'zabbix.dj-wasabi.nl',
#       zabbix_server => 'wdpuppet03.dj-wasabi.local',
#       database_host => 'wdpuppet04.dj-wasabi.local',
#       database_type => 'mysql',
#       puppetgem     => 'gem',
#     }
#   }
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
class zabbix::web (
  $zabbix_url                                                         = $zabbix::params::zabbix_url,
  $database_type                                                      = $zabbix::params::database_type,
  $manage_repo                                                        = $zabbix::params::manage_repo,
  $zabbix_version                                                     = $zabbix::params::zabbix_version,
  $zabbix_timezone                                                    = $zabbix::params::zabbix_timezone,
  $zabbix_package_state                                               = $zabbix::params::zabbix_package_state,
  $zabbix_template_dir                                                = $zabbix::params::zabbix_template_dir,
  $web_config_owner                                                   = $zabbix::params::web_config_owner,
  $web_config_group                                                   = $zabbix::params::web_config_group,
  $manage_vhost                                                       = $zabbix::params::manage_vhost,
  $default_vhost                                                      = $zabbix::params::default_vhost,
  $manage_resources                                                   = $zabbix::params::manage_resources,
  $apache_use_ssl                                                     = $zabbix::params::apache_use_ssl,
  $apache_ssl_cert                                                    = $zabbix::params::apache_ssl_cert,
  $apache_ssl_key                                                     = $zabbix::params::apache_ssl_key,
  $apache_ssl_cipher                                                  = $zabbix::params::apache_ssl_cipher,
  $apache_ssl_chain                                                   = $zabbix::params::apache_ssl_chain,
  $apache_listen_ip                                                   = $zabbix::params::apache_listen_ip,
  Variant[Array[Stdlib::Port], Stdlib::Port] $apache_listenport       = $zabbix::params::apache_listenport,
  Variant[Array[Stdlib::Port], Stdlib::Port] $apache_listenport_ssl   = $zabbix::params::apache_listenport_ssl,
  $zabbix_api_user                                                    = $zabbix::params::server_api_user,
  Variant[Sensitive[String], String] $zabbix_api_pass                 = $zabbix::params::server_api_pass,
  Optional[Array[Stdlib::Host,1]] $zabbix_api_access                  = $zabbix::params::server_api_access,
  $database_host                                                      = $zabbix::params::server_database_host,
  $database_name                                                      = $zabbix::params::server_database_name,
  $database_schema                                                    = $zabbix::params::server_database_schema,
  Boolean $database_double_ieee754                                    = $zabbix::params::server_database_double_ieee754,
  $database_user                                                      = $zabbix::params::server_database_user,
  Variant[Sensitive[String], String] $database_password               = $zabbix::params::server_database_password,
  $database_socket                                                    = $zabbix::params::server_database_socket,
  $database_port                                                      = $zabbix::params::server_database_port,
  $zabbix_server                                                      = $zabbix::params::zabbix_server,
  Optional[String] $zabbix_server_name                                = $zabbix::params::zabbix_server,
  $zabbix_listenport                                                  = $zabbix::params::server_listenport,
  $apache_php_max_execution_time                                      = $zabbix::params::apache_php_max_execution_time,
  $apache_php_memory_limit                                            = $zabbix::params::apache_php_memory_limit,
  $apache_php_post_max_size                                           = $zabbix::params::apache_php_post_max_size,
  $apache_php_upload_max_filesize                                     = $zabbix::params::apache_php_upload_max_filesize,
  $apache_php_max_input_time                                          = $zabbix::params::apache_php_max_input_time,
  $apache_php_always_populate_raw_post_data                           = $zabbix::params::apache_php_always_populate_raw_post_data,
  $apache_php_max_input_vars                                          = $zabbix::params::apache_php_max_input_vars,
  Optional[Stdlib::Absolutepath] $ldap_cacert                         = $zabbix::params::ldap_cacert,
  Optional[Stdlib::Absolutepath] $ldap_clientcert                     = $zabbix::params::ldap_clientcert,
  Optional[Stdlib::Absolutepath] $ldap_clientkey                      = $zabbix::params::ldap_clientkey,
  Optional[Enum['never','allow','try','demand','hard']] $ldap_reqcert = $zabbix::params::ldap_reqcert,
  Optional[Stdlib::Absolutepath] $saml_sp_key                         = $zabbix::params::saml_sp_key,
  Optional[Stdlib::Absolutepath] $saml_sp_cert                        = $zabbix::params::saml_sp_cert,
  Optional[Stdlib::Absolutepath] $saml_idp_cert                       = $zabbix::params::saml_idp_cert,
  Hash[String[1], Variant[ScalarData, Hash]] $saml_settings           = $zabbix::params::saml_settings,
  $puppetgem                                                          = $zabbix::params::puppetgem,
  Boolean $manage_selinux                                             = $zabbix::params::manage_selinux,
  Hash[String[1], Any] $apache_vhost_custom_params                    = {},
) inherits zabbix::params {
  # TODO: use EPP instead of ERB, as EPP can handle Sensitive natively
  $database_password_unsensitive = $database_password.unwrap

  # check osfamily, Arch is currently not supported for web
  if $facts['os']['family'] in ['Archlinux', 'Gentoo',] {
    fail("${facts['os']['family']} is currently not supported for zabbix::web")
  }

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
  }

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
    file { $zabbix_template_dir:
      ensure => directory,
      owner  => 'zabbix',
      group  => 'zabbix',
      mode   => '0755',
    }
    -> class { 'zabbix::zabbixapi':
      zabbix_version => $zabbix_version,
      puppetgem      => $puppetgem,
    }
    -> class { 'zabbix::resources::web':
      zabbix_url     => $zabbix_url,
      zabbix_user    => $zabbix_api_user,
      zabbix_pass    => $zabbix_api_pass,
      apache_use_ssl => $apache_use_ssl,
    }
  }

  case $facts['os']['family'] {
    'Debian': {
      $zabbix_web_package = 'zabbix-frontend-php'
      $php_db_package = "php-${db}"

      package { $php_db_package:
        ensure => $zabbix_package_state,
        before => [
          Package[$zabbix_web_package],
          File['/etc/zabbix/web/zabbix.conf.php'],
        ],
      }
    }
    default: {
      $zabbix_web_package = 'zabbix-web'

      package { "zabbix-web-${db}":
        ensure  => $zabbix_package_state,
        before  => Package[$zabbix_web_package],
        require => Class['zabbix::repo'],
        tag     => 'zabbix',
      }
    }
  } # END case $facts['os']['family']

  file { '/etc/zabbix/web':
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0755',
    require => Package[$zabbix_web_package],
  }

  package { $zabbix_web_package:
    ensure  => $zabbix_package_state,
    before  => File['/etc/zabbix/web/zabbix.conf.php'],
    require => Class['zabbix::repo'],
    tag     => 'zabbix',
  }

  # Webinterface config file
  $content = template('zabbix/web/zabbix.conf.php.erb')
  file { '/etc/zabbix/web/zabbix.conf.php':
    ensure  => file,
    owner   => $web_config_owner,
    group   => $web_config_group,
    mode    => '0640',
    replace => true,
    content => if $database_password =~ Sensitive {
      Sensitive($content)
    } else {
      $content
    },
  }

  # For API to work on Zabbix 5.x zabbix.conf.php needs to be in the root folder.
  file { '/etc/zabbix/zabbix.conf.php':
    ensure => link,
    target => '/etc/zabbix/web/zabbix.conf.php',
    owner  => $web_config_owner,
    group  => $web_config_group,
    mode   => '0640',
  }

  # Is set to true, it will create the apache vhost.
  if $manage_vhost {
    include apache
    include apache::mod::dir
    if $facts['os']['family'] == 'RedHat' {
      include apache::mod::proxy
      include apache::mod::proxy_fcgi
      $apache_vhost_custom_fragment = ''

      service { 'php-fpm':
        ensure => 'running',
        enable => true,
      }

      file { '/etc/php-fpm.d/zabbix.conf':
        ensure  => file,
        notify  => Service['php-fpm'],
        content => epp('zabbix/web/php-fpm.d.zabbix.conf.epp'),
      }

      $fcgi_filematch = {
        path     => '/usr/share/zabbix',
        provider => 'directory',
        addhandlers => [
          {
            extensions => [
              'php',
              'phar',
            ],
            handler => 'proxy:unix:/var/run/php-fpm/zabbix.sock|fcgi://localhost',
          },
        ],
      }
      $proxy_directory = {
        path => 'fcgi://localhost:9000',
        provider => 'proxy',
      }
    }
    else {
      include apache::mod::php

      $apache_vhost_custom_fragment = "
        php_value max_execution_time ${apache_php_max_execution_time}
        php_value memory_limit ${apache_php_memory_limit}
        php_value post_max_size ${apache_php_post_max_size}
        php_value upload_max_filesize ${apache_php_upload_max_filesize}
        php_value max_input_time ${apache_php_max_input_time}
        php_value always_populate_raw_post_data ${apache_php_always_populate_raw_post_data}
        php_value max_input_vars ${apache_php_max_input_vars}
        # Set correct timezone
        php_value date.timezone ${zabbix_timezone}"
      $fcgi_filematch = {}
      $proxy_directory = {}
    }
    # Check if we use ssl. If so, we also create an non ssl
    # vhost for redirect traffic from non ssl to ssl site.
    if $apache_use_ssl {
      # Listen port
      $apache_listen_port = $apache_listenport_ssl

      # We create nonssl vhost for redirecting non ssl
      # traffic to https.
      apache::vhost { "${zabbix_url}_nonssl":
        docroot        => '/usr/share/zabbix',
        manage_docroot => false,
        default_vhost  => $default_vhost,
        port           => $apache_listenport,
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
      $apache_listen_port = $apache_listenport
    }

    $location_api_access = $zabbix_api_access ? {
      undef   => 'all granted',
      default => $zabbix_api_access.map |$host| { "host ${host}" },
    }

    apache::vhost { $zabbix_url:
      docroot         => '/usr/share/zabbix',
      ip              => $apache_listen_ip,
      port            => $apache_listen_port,
      default_vhost   => $default_vhost,
      add_listen      => true,
      directories     => [
        merge({
            path     => '/usr/share/zabbix',
            provider => 'directory',
            require  => 'all granted',
          }, $fcgi_filematch
        ),
        {
          path     => '/usr/share/zabbix/conf',
          provider => 'directory',
          require  => 'all denied',
        },
        {
          path     => '/usr/share/zabbix/api',
          provider => 'directory',
          require  => 'all denied',
        },
        {
          path     => '/usr/share/zabbix/include',
          provider => 'directory',
          require  => 'all denied',
        },
        {
          path     => '/usr/share/zabbix/include/classes',
          provider => 'directory',
          require  => 'all denied',
        },
        {
          path     => '/api_jsonrpc.php',
          provider => 'location',
          require  => $location_api_access,
        },
      ],
      custom_fragment => $apache_vhost_custom_fragment,
      rewrites        => [
        {
        rewrite_rule => ['^$ /index.php [L]'] }
      ],
      ssl             => $apache_use_ssl,
      ssl_cert        => $apache_ssl_cert,
      ssl_key         => $apache_ssl_key,
      ssl_cipher      => $apache_ssl_cipher,
      ssl_chain       => $apache_ssl_chain,
      require         => Package[$zabbix_web_package],
      *               => $apache_vhost_custom_params,
    }
  } # END if $manage_vhost

  # check if selinux is active and allow zabbix
  if fact('os.selinux.enabled') == true and $manage_selinux {
    # allow httpd to speak to the zabbix service
    selboolean { 'httpd_can_connect_zabbix':
      persistent => true,
      value      => 'on',
    }
    # allow httpd to speak to the database
    selboolean { 'httpd_can_network_connect_db':
      persistent => true,
      value      => 'on',
    }
  }
}
