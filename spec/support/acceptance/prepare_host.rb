def prepare_host
  if fact('os.family') == 'RedHat'
    shell('rm -rf /etc/yum.repos.d/Zabbix*.repo; rm -rf /var/cache/yum/x86_64/*/Zabbix*; yum clean all --verbose')
    # The CentOS docker image has a yum config that won't install docs, to keep used space low
    # zabbix packages their SQL file as doc, we need that for bootstrapping the database
    if fact('os.release.major').to_i == 7
      shell('sed -i "/nodocs/d" /etc/yum.conf')
    end
  end
  cleanup_script = <<-SHELL
  /opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-server-mysql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-server-mysql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-pgsql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-mysql ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-pgsql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-web-mysql-scl ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-frontend-php ensure=purged
  rm -f /etc/zabbix/.*done
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL
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
