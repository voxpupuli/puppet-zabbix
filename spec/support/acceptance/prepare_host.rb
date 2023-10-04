# frozen_string_literal: true

def prepare_host
  if fact('os.family') == 'RedHat'
    shell('rm -rf /etc/yum.repos.d/Zabbix*.repo; rm -rf /var/cache/yum/x86_64/*/Zabbix*; yum clean all --verbose')
    # The CentOS docker image has a yum config that won't install docs, to keep used space low
    # zabbix packages their SQL file as doc, we need that for bootstrapping the database
    shell('sed -i "/nodocs/d" /etc/yum.conf') if fact('os.release.major').to_i == 7
  end

  # The Ubuntu 18.04+ docker image has a dpkg config that won't install docs, to keep used space low
  # zabbix packages their SQL file as doc, we need that for bootstrapping the database
  shell('rm -f /etc/dpkg/dpkg.cfg.d/excludes') if fact('os.distro.id') == 'Ubuntu'

  # On Debian it seems that make is searching for mkdir in /usr/bin/ but mkdir
  # does not exist. Symlink it from /bin/mkdir to make it work.
  shell('ln -sf /bin/mkdir /usr/bin/mkdir') if fact('os.distro.id') == 'Debian'

  cleanup_puppet = <<-SHELL
      $services = $facts['os']['family'] ? {
        'RedHat' => ['zabbix-server', 'httpd'],
        'Debian' => ['zabbix-server', 'apache2'],
        default  => [],
      }
      service { $services:
        ensure => stopped
      }

      $packages = $facts['os']['family'] ? {
        'RedHat' => ['zabbix-server-pgsql', 'zabbix-server-pgsql-scl', 'zabbix-web', 'zabbix-web-pgsql', 'zabbix-web-pgsql-scl', 'zabbix-frontend-php', 'zabbix-sql-scripts'],
        'Debian' => ['zabbix-server-pgsql', 'zabbix-web-pgsql', 'zabbix-frontend-php', 'zabbix-sql-scripts'],
        default  => [],
      }
      package { $packages:
        ensure => purged
      }
  SHELL

  cleanup_script = <<-SHELL
  /opt/puppetlabs/puppet/bin/gem uninstall zabbixapi -a
  rm -f /etc/zabbix/.*done
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL

  apply_manifest(cleanup_puppet)
  shell(cleanup_script)

  install_deps = <<-SHELL
      $compile_packages = $facts['os']['family'] ? {
        'RedHat' => [ 'make', 'gcc-c++', 'rubygems', 'ruby'],
        'Debian' => [ 'make', 'g++', 'ruby-dev', 'ruby', 'pkg-config',],
        default  => [],
      }
      package { $compile_packages:
        ensure => 'present',
      }
  SHELL
  apply_manifest(install_deps)
end
