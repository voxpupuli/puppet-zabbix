def prepare_host
  if fact('os.family') == 'RedHat'
    shell('rm -rf /etc/yum.repos.d/Zabbix*.repo; rm -rf /var/cache/yum/x86_64/*/Zabbix*; yum clean all --verbose')
    if fact('os.release.major').to_i == 7
      shell('sed -i "/nodocs/d" /etc/yum.conf')
    end
  end
  cleanup_script = <<-SHELL
  /opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped
  /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged
  rm -f /etc/zabbix/.*done
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL
  shell(cleanup_script)
end
