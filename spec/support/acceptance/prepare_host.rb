# frozen_string_literal: true

def prepare_host
  if fact('os.family') == 'RedHat'
    shell('yum clean all --verbose; rm -rf /etc/yum.repos.d/Zabbix*.repo')
  end

  apply_manifest <<~PUPPET
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
  PUPPET

  shell <<~SHELL
    /opt/puppetlabs/puppet/bin/gem uninstall zabbixapi -a
    rm -f /etc/zabbix/.*done
    if id postgres > /dev/null 2>&1; then
      su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
    fi
  SHELL
end
