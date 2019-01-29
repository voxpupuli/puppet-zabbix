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

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
