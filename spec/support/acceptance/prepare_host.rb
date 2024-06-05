# frozen_string_literal: true

def prepare_host
  shell('yum clean all --verbose; rm -rf /etc/yum.repos.d/Zabbix*.repo') if fact('os.family') == 'RedHat'

  apply_manifest <<~PUPPET
    $services = $facts['os']['family'] ? {
      'RedHat' => ['zabbix-server', 'httpd', 'zabbix-agentd', 'zabbix-agent', 'zabbix-agent2', 'zabbix-proxy'],
      'Debian' => ['zabbix-server', 'apache2', 'zabbix-agentd', 'zabbix-agent', 'zabbix-agent2', 'zabbix-proxy'],
      default  => ['zabbix-agentd', 'zabbix-agent', 'zabbix-agent2'],
    }
    service { $services:
      ensure => stopped
    }

    $packages = $facts['os']['family'] ? {
      'RedHat' => ['zabbix-server-pgsql', 'zabbix-server-pgsql-scl', 'zabbix-web', 'zabbix-web-pgsql', 'zabbix-web-pgsql-scl', 'zabbix-frontend-php', 'zabbix-sql-scripts', 'zabbix-agent', 'zabbix-agent2', 'zabbix-proxy-pgsql'],
      'Debian' => ['zabbix-server-pgsql', 'zabbix-web-pgsql', 'zabbix-frontend-php', 'zabbix-sql-scripts', 'zabbix-agent', 'zabbix-agent2', 'zabbix-proxy-pgsql'],
      default  => ['zabbix-agent', 'zabbix-agent2'],
    }

    $pkg_ensure = $facts['os']['family'] ? {
      'Archlinux' => absent,
      default     => purged,
    }

    package { $packages:
      ensure => $pkg_ensure
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
