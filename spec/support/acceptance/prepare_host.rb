# frozen_string_literal: true

def prepare_host
  if fact('os.family') == 'RedHat'
    shell('rm -rf /etc/yum.repos.d/Zabbix*.repo; rm -rf /var/cache/yum/x86_64/*/Zabbix*; yum clean all --verbose')
  end

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
end
