def prepare_host
  if fact('os.family') == 'RedHat'
    shell('rm -rf /etc/yum.repos.d/Zabbix*.repo; rm -rf /var/cache/yum/x86_64/*/Zabbix*; yum clean all --verbose')
    # The CentOS docker image has a yum config that won't install docs, to keep used space low
    # zabbix packages their SQL file as doc, we need that for bootstrapping the database
    if fact('os.release.major').to_i == 7
      shell('sed -i "/nodocs/d" /etc/yum.conf')
    end
  end

  # The Ubuntu 18.04+ docker image has a dpkg config that won't install docs, to keep used space low
  # zabbix packages their SQL file as doc, we need that for bootstrapping the database
  if fact('os.distro.id') == 'Ubuntu'
    shell('rm -f /etc/dpkg/dpkg.cfg.d/excludes')
  end

  # On Debian it seems that make is searching for mkdir in /usr/bin/ but mkdir
  # does not exist. Symlink it from /bin/mkdir to make it work.
  shell('ln -sf /bin/mkdir /usr/bin/mkdir') if fact('os.distro.id') == 'Debian'

  cleanup_script_debian = <<-SHELL
  /opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped
  /opt/puppetlabs/bin/puppet resource service apache2 ensure=stopped
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-frontend-php ensure=purged
  /opt/puppetlabs/puppet/bin/gem uninstall zabbixapi -a
  rm -f /etc/zabbix/.*done
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL

  cleanup_script_redhat = <<-SHELL
  /opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped
  /opt/puppetlabs/bin/puppet resource service httpd ensure=stopped
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-pgsql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-frontend-php ensure=purged
  /opt/puppetlabs/puppet/bin/gem uninstall zabbixapi -a
  rm -f /etc/zabbix/.*done
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL

  shell(cleanup_script_debian) if fact('os.family') == 'Debian'
  shell(cleanup_script_redhat) if fact('os.family') == 'RedHat'

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
