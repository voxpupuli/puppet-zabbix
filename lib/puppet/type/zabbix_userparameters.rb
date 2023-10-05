# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
Puppet::Type.newtype(:zabbix_userparameters) do
  @doc = 'Manage zabbix user templates'

  ensurable do
    desc 'The basic property that the resource should be in.'
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
