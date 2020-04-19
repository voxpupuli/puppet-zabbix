def cleanup_zabbix
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
