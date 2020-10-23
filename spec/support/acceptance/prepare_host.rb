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
  /opt/puppetlabs/bin/puppet resource package zabbix-web ensure=purged
  /opt/puppetlabs/bin/puppet resource package zabbix-frontend-php ensure=purged
  /opt/puppetlabs/bin/puppet resource package apache2 ensure=purged
  /opt/puppetlabs/bin/puppet resource package httpd ensure=purged
  rm -f /etc/zabbix/.*done
  rm -rf /etc/httpd
  rm -rf /etc/apache2
  rm -rf /var/www
  if id postgres > /dev/null 2>&1; then
    su - postgres -c "psql -c 'drop database if exists zabbix_server;'"
  fi
  SHELL
  shell(cleanup_script)
end
