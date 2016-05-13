$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
Puppet::Type.newtype(:zabbix_userparameters) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'An unique name for this define.'
  end

  newparam(:hostname) do
    desc 'FQDN of the machine.'
  end

  newparam(:template) do
    desc 'Template which should be loaded for this host.'
  end

  newparam(:zabbix_url) do
    desc 'The url on which the zabbix-api is available.'
  end

  newparam(:zabbix_user) do
    desc 'Zabbix-api username.'
  end

  newparam(:zabbix_pass) do
    desc 'Zabbix-api password.'
  end

  newparam(:apache_use_ssl) do
    desc 'If apache is uses with ssl'
  end
end
