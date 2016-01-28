Puppet::Type.newtype(:zabbix_template) do

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:template_name, :namevar => true) do
      desc 'The name of template.'
  end

  newparam(:template_source) do
      desc 'Template source file.'
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

